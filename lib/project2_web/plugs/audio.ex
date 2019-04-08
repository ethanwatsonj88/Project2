defmodule Project2Web.Audio do
  @chunk_size 128
  use Project2Web, :controller

  alias Project2.Songs
  alias Project2.Songs.Song
  def init(opts), do: opts

  def song(conn, %{"id" => id}) do
    song = Songs.get_song!(id)
    client = get_session(conn, :client)
    x = OAuth2.Client.get!(client,
           "https://www.googleapis.com/drive/v3/files/"
           <> song.link <> "?alt=media").body
#    data = data
#      |> String.to_charlist()
#      |> tl()
#      |> Enum.reverse()
#      |> tl()
#      |> Enum.reverse()
#      |> to_string()
    #IO.inspect(data, printable_limit: :infinity)
    #{:ok, x} = Base.decode64(data)
#		IO.puts "\n\n\n\n\n\n\ AAAAAAAaa\n\n\n\n\n"
		inspect File.open("priv/static/song.mp3", [:write])
#		IO.puts "AAAAAFDFFFFF"
    {:ok, file} = File.open("song.mp3", [:write])
    IO.binwrite(file, x)
    IO.inspect(x)
    #IO.puts "inspecting data"
    #IO.inspect data
    conn = conn
    |> send_chunked(200)

    File.stream!("song.mp3", [], @chunk_size)
    |> Enum.into(conn)
  end
end
