# Tmux Line Clean

Clean up lines in the current pane.  
Can move like vim!

![demo.gif](https://user-images.githubusercontent.com/17779386/97801891-43e05180-1c83-11eb-8aa5-48b1b98de634.gif)

## Requirement

- tmux

## Installation

### Using Homebrew

```bash
$ brew tap Rasukarusan/tap
$ brew install Rasukarusan/tap/tmux-line-clean
```

### Manually

```bash
$ git clone git@github.com:Rasukarusan/tmux-line-clean.git
$ mv tmux-line-clean/tmux-line-clean /usr/local/bin/
```

## Usage

```bash
$ tmux-line-clean
```
Run above the command, enter the `delete mode`. Move cursor like vim keybinds.

| key | description |
| ------ | ------ |
| k   | move cursor up |
| j   | move cursor down   |
| g   | move cursor to top of pane |
| G   | move cursor to bottom of pane |

## Setting

#### zsh keybind (recommended)
.zshrc
```bash
function line_cleaner() {
  tmux-line-clean
  zle accept-line
}
zle -N line_cleaner
bindkey '^k' line_cleaner
```

#### tmux keybind
.tmux.conf
```sh
bind-key k send 'tmux-line-clean' ENTER
```

## Bonus Examples

There are several scripts, such as one that doesn't use tmux, one that uses stty, and one that uses visual mode.  
`not-using-tmux` can only delete line.  
`using-stty`'s behavior is the same as the demo GIF.  
`visual mode`'s behavior is the following GIF.

![demo_visualmode.gif](https://user-images.githubusercontent.com/17779386/97842280-b9ebc380-1d2a-11eb-8af7-64c1dd0bcc1f.gif)

### License

[MIT](LICENSE)
