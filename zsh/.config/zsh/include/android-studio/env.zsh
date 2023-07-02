# https://developer.android.com/tools/variables

if [ -d "$HOME/Library/Android/sdk" ]; then
	export ANDROID_HOME="$HOME/Library/Android/sdk"
	export ANDROID_SDK_ROOT="$ANDROID_HOME" # This is deprecated but some Up shit needs it

	export PATH="$ANDROID_HOME/emulator:$PATH"
	export PATH="$ANDROID_HOME/tools:$PATH"
	export PATH="$ANDROID_HOME/tools/bin:$PATH"
	export PATH="$ANDROID_HOME/platform-tools:$PATH"
	export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH" # _must_ be after tools/bin
fi
