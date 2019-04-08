defmodule Project2Web.SongController do
  use Project2Web, :controller

  alias Project2.Songs
  alias Project2.Songs.Song

  def index(conn, _params) do
    songs = Songs.list_songs()
    render(conn, "index.html", songs: songs)
  end

  def new(conn, _params) do
    changeset = Songs.change_song(%Song{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"song" => song_params}) do
    song_params = if song_params != nil && Map.has_key?(song_params, "music") do
                 client = get_session(conn, :client)
                 {:ok, fun} = File.read(song_params["music"].path)
                 data = OAuth2.Client.post!(
                        OAuth2.Client.put_header(client, "Content-Type", "audio/mpeg"),
                        "https://www.googleapis.com/upload/drive/v3/files?uploadType=media",
                        fun).body
                 OAuth2.Client.patch!(
                        OAuth2.Client.put_header(client, "Content-Type", "application/json"),
                        "https://www.googleapis.com/drive/v3/files/" <> data["id"],
                        %{name: song_params["name"]})
                 OAuth2.Client.post!(
                        OAuth2.Client.put_header(client, "Content-Type", "application/json"),
                        "https://www.googleapis.com/drive/v3/files/" <>
                        data["id"] <> "/permissions",
                        %{type: "anyone", role: "reader"}).body
                 webLink = OAuth2.Client.get!(client,
                        "https://www.googleapis.com/drive/v3/files/"
                        <> data["id"] <> "?fields=webContentLink").body
                 IO.inspect webLink
                 Map.put(song_params, "link", data["id"])
                 |> Map.put("webLink", webLink["webContentLink"])
                 |> Map.delete("music")
                 else
                   song_params
                 end
    case Songs.create_song(song_params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "Song created successfully.")
        |> redirect(to: Routes.song_path(conn, :show, song))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    song = Songs.get_song!(id)
    render(conn, "show.html", song: song)
  end

  def edit(conn, %{"id" => id}) do
    song = Songs.get_song!(id)
    changeset = Songs.change_song(song)
    render(conn, "edit.html", song: song, changeset: changeset)
  end

  def update(conn, %{"id" => id, "song" => song_params}) do
    song = Songs.get_song!(id)

    case Songs.update_song(song, song_params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "Song updated successfully.")
        |> redirect(to: Routes.song_path(conn, :show, song))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", song: song, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    song = Songs.get_song!(id)

    client = get_session(conn, :client)
    data = OAuth2.Client.delete!(client,
           "https://www.googleapis.com/drive/v3/files/" <> song.link).body

    IO.inspect song
    {:ok, _song} = Songs.delete_song(song)
    conn
    |> put_flash(:info, "Song deleted successfully.")
    |> redirect(to: Routes.song_path(conn, :index))
  end
end
