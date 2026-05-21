# iptables-legacy + ipset backend
# Drop-in replacement for nft.sh
# Requires: ipset, iptables-legacy, kmod-ipt-tproxy, kmod-ipt-ipset

IPT="iptables-legacy"
IPT6="ip6tables-legacy"

# ---------------------------------------------------------------------------
# ipset helpers (replace nft sets)
# ---------------------------------------------------------------------------

# Create an ipset of type hash:net (IPv4 subnets/addresses)
ipt_create_ipv4_set() {
    local name="$1"
    if ! ipset list "$name" > /dev/null 2>&1; then
        ipset create "$name" hash:net family inet hashsize 4096 maxelem 65536
    fi
}

# Create an ipset of type hash:net for Discord (same type, different name)
ipt_create_discord_set() {
    local name="$1"
    ipt_create_ipv4_set "$name"
}

# Add one or more CIDR elements to an ipset.
# Elements may be comma-separated: "1.2.3.0/24,5.6.7.0/24"
ipt_add_set_elements() {
    local name="$1"
    local elements="$2"

    # Replace commas with newlines and feed to ipset
    echo "$elements" | tr ',' '\n' | while IFS= read -r elem; do
        elem=$(echo "$elem" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [ -z "$elem" ] && continue
        ipset add "$name" "$elem" 2>/dev/null || true
    done
}

# Add elements from a file (one CIDR per line) in chunks to avoid huge commands
ipt_add_set_elements_from_file_chunked() {
    local filepath="$1"
    local _table="$2"   # ignored – kept for API compatibility with nft.sh
    local set_name="$3"
    # $4 chunk_size – ignored; ipset add is per-line anyway

    local count=0
    while IFS= read -r line; do
        line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [ -z "$line" ] && continue

        if ! is_ipv4 "$line" && ! is_ipv4_cidr "$line"; then
            log "'$line' is not IPv4 or IPv4 CIDR" "debug"
            continue
        fi

        ipset add "$set_name" "$line" 2>/dev/null || true
        count=$((count + 1))
    done < "$filepath"

    log "Added $count elements to ipset $set_name" "debug"
}

# ---------------------------------------------------------------------------
# Provide the same public symbols that nft.sh exported so callers need
# minimal changes.  Map nft_* → ipt_* wrappers.
# ---------------------------------------------------------------------------

nft_create_ipv4_set() {
    ipt_create_ipv4_set "$2"          # $1=table (ignored), $2=name
}

nft_create_ifname_set() {
    : # iptables uses -i match directly; no ifname set needed
}

nft_add_set_elements() {
    ipt_add_set_elements "$2" "$3"    # $1=table (ignored)
}

nft_add_set_elements_from_file_chunked() {
    ipt_add_set_elements_from_file_chunked "$1" "$2" "$3" "$4"
}
