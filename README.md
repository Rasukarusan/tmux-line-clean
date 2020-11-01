# Tmux Line Delete

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
$ git clone https://github.com/Rasukarusan/tmux-line-clean.git
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

### License

[MIT](LICENSE)
