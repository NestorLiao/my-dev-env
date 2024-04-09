default: run test monitor clean build deploy lint

copyjustfile:
  find . -type d ! -path "./.git*" ! -path "./.direnv*"  -exec cp -f justfile {} \;


# keys for run custom command to panel 2
analysis:
  echo 'Analysising!'
run:
  cargo run
test:
  echo 'Testing!'
monitor:
  echo 'Monitoring!'
clean:
  echo 'Cleaning!'
build:
  echo 'Building!'
deploy:
  echo 'Deploying!'
lint:
  echo 'Linting!'

alias R :=run
alias A :=analysis
alias T :=test
alias M :=monitor
alias C :=clean
alias B :=build
alias D :=deploy
alias L :=lint

# keys for calling commands in editor to execute other tmux panel
a:
  tmux send-keys -t 2 "just analysis" C-m;
r:
  tmux send-keys -t 2 "just run" C-m;
t:
  tmux send-keys -t 2 "just test" C-m;
n:
  tmux send-keys -t 2 "just monitor" C-m;
e:
  tmux send-keys -t 2 "just clean" C-m;
i:
  tmux send-keys -t 2 "just build" C-m;
o:
  tmux send-keys -t 2 "just deploy" C-m;
l:
  tmux send-keys -t 2 "just lint" C-m;
s:
  tmux send-keys -t 2 "just default" C-m;
c:
  tmux send-keys -t 2  C-C;
u:
  tmux send-keys -t 2 PageUp;
d:
  tmux send-keys -t 2 PageDown;
q:
  tmux send-keys -t 2 q;
