import { Socket } from "phoenix";

class HangmanServer {

  constructor(tally) {
    this.tally = tally;
    this.socket = new Socket("/socket", {});
    this.socket.connect();
  }

  connect() {
    this.setupChannel();
    this.channel
        .join()
        .receive("ok", resp => {
          console.log(`connected: ${resp}`);
          this.fetchTally();
        })
        .receive("error", resp => {
          throw(resp);
        });
  }

  setupChannel() {
    this.channel = this.socket.channel("hangman:game", {});
    this.channel.on("tally", tally => {
      this.copyTally(tally);
    });
  }

  fetchTally() {
    this.channel.push("tally", {});
  }

  copyTally(from) {
    for (let k in from) {
      this.tally[k] = from[k];
    }
  }

  newGame(guess) {
    this.channel.push("new_game", {});
  }

  makeMove(guess) {
    this.channel.push("make_move", guess);
  }
}


export default HangmanServer;
