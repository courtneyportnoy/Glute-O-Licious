class Music {
  float bx, by, bw, bh;
  boolean playing = false;

  Music(int tempX) {
    bx = tempX - 200;
    by = 500;
    bw = 187;
    bh = 85;
  }

  void display() {
    if (!playing) {
      image(musicPlay, bx, by);
    }
    else {
      image(musicPause, bx, by);
    }
  }

  boolean overButton() {
    return ((mouseX > bx) && (mouseX < bx + bw)
      && (mouseY > by) && (mouseY < by + bh)) ;
  }

  void mouseClicked() {
    if (!playing) {
      if (mouseX > bx + 66 && mouseX < bx + 115 && mouseY < by + bh && mouseY > by) {
        player.play();
        playing = true;
      }
    }
    else {
      if (mouseX < bx + bw && mouseX > bx + bw - 55 && mouseY < by + bh && mouseY > by) {
        player.close();       
        if (currentSong == song.length-1) {
          currentSong = 0;
        }
        else {
          currentSong++;
        }
        thisSong = song[currentSong];
        player = minim.loadFile(thisSong);
        player.play();
      }
      else if (mouseX < bx + 55 && mouseX > bx && mouseY < by + bh && mouseY > by) {
        player.close();
        if (currentSong == 0) {
          currentSong = song.length-1;
        }
        else {
          currentSong--;
        }
        thisSong = song[currentSong];
        player = minim.loadFile(thisSong);
        player.play();
      }
      if (mouseX > bx + 66 && mouseX < bx + 115 && mouseY < by + bh && mouseY > by) {
        player.pause();
        playing = false;
      }
    }
  }
}

