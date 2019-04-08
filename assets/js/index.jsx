import React from 'react';
import ReactDOM from 'react-dom';

export default function index_init(root, channel) {
  ReactDOM.render(<Index channel={channel}/>, root);
}

let hasBeenJoined = false;

class Index extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      last_join: "",
    };
    this.channel = props.channel;

    if (!hasBeenJoined) {
      hasBeenJoined = true;
      this.channel
        .join()
        .receive("ok", this.got_view.bind(this))
        .receive("error", resp=>{console.log("Unable to join", resp);});
    }
    this.channel.on("last_join", this.got_view.bind(this))
    if (window.username) {
      this.channel
        .push("last_join", {"last_join": window.username})
        .receive("ok", this.got_view.bind(this))
        .receive("error", resp=>{console.log("error?", resp)});
    }
  }

  got_view(view) {
    console.log(view)
    this.setState({last_join: view.last_join});
  }

  renderLastJoin() {
    if (window.username) {
      return <div className="col-12">
        <h4>Hi {window.username}!</h4>
        <h4>Recent Activity</h4>
        <h6>{this.state.last_join} visited this page!</h6>
      </div>
    } else {
      return <div className="col-12">
      </div>
    }
  }

  render() {
    return <div className="row" id="root">
    	<div className="col-12">
    		<h1>Welcome to ProdHelp</h1>
    	</div>
    	<div className="col-12">
        <a href="/auth"><h2>Sign In with Google</h2></a>
    	</div>
      {this.renderLastJoin()}
    </div>;
  }
}
