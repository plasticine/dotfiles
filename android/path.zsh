if [ -x /usr/libexec/java_home ]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
  export PATH="${JAVA_HOME}/bin:${PATH}"
fi
export ANDROID_SDK=${HOME}/Library/Android/sdk
export ANDROID_HOME=${ANDROID_SDK}
export ANDROID_NDK_HOME="${ANDROID_HOME}/ndk/21.1.6352462"
export PATH=${ANDROID_SDK}/emulator:${ANDROID_SDK}/tools:${ANDROID_SDK}/tools/bin:${PATH}
export PATH=${ANDROID_SDK}/platform-tools:${PATH}
