# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"

awsaddr='ubuntu@ec2-44-201-78-161.compute-1.amazonaws.com'

alias aws='sudo ssh -i ~/.ssh/network_lab.pem $awsaddr'
