export DYLD_FALLBACK_LIBRARY_PATH="$BOXEN_HOME/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH"

if [ -x /usr/libexec/java_home ]; then
  export JAVA_HOME=`/usr/libexec/java_home`
fi
