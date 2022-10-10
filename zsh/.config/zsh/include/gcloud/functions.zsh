# GCP Gcloud configuration switcher...
gcp() {
	gcloud config configurations list \
		--sort-by=~is_active \
		--format '
			table(
				is_active.color(green=True):sort=1:label="Active",
				name:label="Name",
				properties.core.account:label="Account"
			)
		' \
	| fzf \
		--ansi \
		--cycle \
		--border \
		--prompt "Activate Configuration: " \
		--header-lines=1 \
		--reverse \
	| awk '{print $2}' \
	| xargs -n 1 gcloud config configurations activate
}
