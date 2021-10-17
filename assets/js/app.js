// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css";

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

var counter = new WebSocket("ws://localhost:4000/websocket/counter");
counter.addEventListener("open", (event) => {
  counter.send("start counter");
  setInterval(() => {
    if (counter.readyState == counter.OPEN) {
      counter.send("ping");
    }
  }, 20000);
});

counter.addEventListener("message", (event) => {
  console.log("Counter: ", event.data);
});

counter.addEventListener("close", (event) => {
  console.log("Counter connection was closed.");
});

var name = Math.random().toString(32).substring(2);
var chat = new WebSocket("ws://localhost:4000/websocket/chat", name);
chat.addEventListener("open", (event) => {
  setInterval(() => {
    if (chat.readyState == chat.OPEN) {
      chat.send("ping");
    }
  }, 20000);
});

var timeline = document.querySelector(".chat");
chat.addEventListener("message", (event) => {
  console.log("Chat: ", event.data);
  if (event.data !== "pong") {
    timeline.insertAdjacentHTML("beforeend", `<p>${event.data}</p>`);
  }
});

chat.addEventListener("close", (event) => {
  console.log("Chat connection was closed.");
});

var postButton = document.getElementById("post");
postButton.addEventListener("click", (event) => {
  chat.send("Hi!");
});
