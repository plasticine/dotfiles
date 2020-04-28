if [ -z ${ANDROID_HOME+x} ]; then
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export ANDROID_SDK=$ANDROID_HOME
  export PATH=$ANDROID_HOME/emulator:$PATH
  export PATH=$ANDROID_HOME/platform-tools:$PATH
  export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
fi
