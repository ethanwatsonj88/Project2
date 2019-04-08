defmodule Project2Web.Audio do
  @chunk_size 128
  use Project2Web, :controller

  alias Project2.Songs
  alias Project2.Songs.Song
  def init(opts), do: opts

  def song(conn, %{"id" => id}) do
    song = Songs.get_song!(id)
    client = get_session(conn, :client)
    x = HTTPoison.get!(song.webLink <> "?alt=media", [], follow_redirect: true).body
		inspect File.open("priv/static/song.mp3", [:write])
    {:ok, file} = File.open("song.mp3", [:write])
    IO.binwrite(file, x)
    IO.inspect(x)
    conn = conn
    |> send_chunked(200)

    File.stream!("song.mp3", [], @chunk_size)
    |> Enum.into(conn)
  end
end
