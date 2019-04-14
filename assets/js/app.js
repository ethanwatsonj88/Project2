// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import index_init from "./index"
import chat_init from "./chat"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"

$(() => {
  let root = document.getElementById('root');
  let chat_root = document.getElementById('chat_root');
  if (root) {
    let channel = socket.channel("listeners:" + "hi", {})
    index_init(root, channel);
  } else if (chat_root) {
    let channel = socket.channel("chat:" + window.songid, {})
    chat_init(chat_root, channel);
  }
});
