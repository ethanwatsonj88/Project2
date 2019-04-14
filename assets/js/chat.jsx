import React from 'react';
import ReactDOM from 'react-dom';
import _ from "lodash";

export default function chat_init(root, channel) {
  ReactDOM.render(<Chat channel={channel}/>, root);
}

let hasBeenJoined = false;

class Chat extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      names: [],
      msgs: [],
      userin: "",
    };
    this.channel = props.channel;

    if (!hasBeenJoined) {
      hasBeenJoined = true;
      this.channel
        .join()
        .receive("ok", this.got_view.bind(this))
        .receive("error", resp=>{console.log("Unable to join", resp);});
    }
    this.channel.on("msg", this.got_msg.bind(this))
  }

  got_view(view) {
    return;
  }

  got_msg(view) {
    let addMsg = _.clone(this.state.msgs);
    let addName = _.clone(this.state.names);
    addMsg.push(view.msg)
    addName.push(view.name)
    this.setState({msgs: addMsg,
                   names: addName,
                   userin: this.state.userin});
  }

  on_in(ev) {
    let st1 = _.assign({}, this.state, {userin: (ev.target.value)});
    this.setState(st1);
  }

  sub(ev) {
    this.channel
      .push("msg", {"msg": this.state.userin, "name": window.username})
      .receive("ok", this.got_view.bind(this))
      .receive("error", resp=>{console.log("error?", resp)});
  }

  render() {
    return <div className="row" id="chat_root">
    	<div className="col-12">
      <div>
        <UserInput userin={this.state.userin}
                   on_in={this.on_in.bind(this)}
                   sub={this.sub.bind(this)} />
      </div>
      <div>
        <ViewComments msgs={this.state.msgs} names={this.state.names} />
      </div>
      </div>
      </div>
  }
}

function UserInput(params) {
  let {userin, on_in, sub} = params
  if (window.username) {
    return <div>
      <p><b>Type Your Comments</b></p>
      <input type="text" value={userin} onChange={on_in} />
      <button type="button" className="btn btn-primary" onClick={sub}>
        submit
      </button>
      </div>
    } else {
      return <div></div>;
    }
}

function ViewComments(params) {
  let {msgs, names} = params
  let table = []
  for (let ii = 0; ii < msgs.length; ii = ii + 1) {
    table.push(<div className="card" key={ii}>
                 <div className="card-body">
                   <h5 className="card-title">{names[ii]}</h5>
                   <h5 className="card-subtitle mb-2 text-muted">{msgs[ii]}</h5>
                 </div>
               </div>)
  }

  return table
}
