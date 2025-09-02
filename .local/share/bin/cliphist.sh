#!/usr/bin/env sh

# Set variables
scrDir=$(dirname "$(realpath "$0")")
favoritesFile="${HOME}/.cliphist_favorites"

# Show main menu if no arguments are passed
if [ $# -eq 0 ]; then
    main_action=$(echo -e "History\nDelete\nView Favorites\nManage Favorites\nClear History" | fuzzel --dmenu --prompt="Choose a clipboard action: ")
else
    main_action="History"
fi

case "${main_action}" in
"History")
    selected_item=$(cliphist list | fuzzel --dmenu --prompt="Clipboard History ")
    if [ -n "$selected_item" ]; then
        echo "$selected_item" | cliphist decode | wl-copy
        notify-send "Copied to clipboard."
    fi
    ;;
"Delete")
    selected_item=$(cliphist list | fuzzel --dmenu --prompt="Delete an entry ")
    if [ -n "$selected_item" ]; then
        echo "$selected_item" | cliphist delete
        notify-send "Deleted."
    fi
    ;;
"View Favorites")
    if [ -f "$favoritesFile" ] && [ -s "$favoritesFile" ]; then
        # Read each Base64 encoded favorite as a separate line
        mapfile -t favorites < "$favoritesFile"

        # Prepare a list of decoded single-line representations for fuzzel
        decoded_lines=()
        for favorite in "${favorites[@]}"; do
            decoded_favorite=$(echo "$favorite" | base64 --decode)
            # Replace newlines with spaces for fuzzel display
            single_line_favorite=$(echo "$decoded_favorite" | tr '\n' ' ')
            decoded_lines+=("$single_line_favorite")
        done

        selected_favorite=$(printf "%s\n" "${decoded_lines[@]}" | fuzzel --dmenu --prompt="Favourites ")
        if [ -n "$selected_favorite" ]; then
            # Find the index of the selected favorite
            index=$(printf "%s\n" "${decoded_lines[@]}" | grep -nxF "$selected_favorite" | cut -d: -f1)
            # Use the index to get the Base64 encoded favorite
            if [ -n "$index" ]; then
                selected_encoded_favorite="${favorites[$((index - 1))]}"
                # Decode and copy the full multi-line content to clipboard
                echo "$selected_encoded_favorite" | base64 --decode | wl-copy
                notify-send "Copied to clipboard."
            else
                notify-send "Error: Selected favorite not found."
            fi
        fi
    else
        notify-send "No favorites."
    fi
    ;;
"Manage Favorites")
    manage_action=$(echo -e "Add to Favorites\nRemove from Favorites\nClear All Favorites" | fuzzel --dmenu --prompt="Manage Favourites ")

    case "${manage_action}" in
    "Add to Favorites")
        # Show clipboard history to add to favorites
        item=$(cliphist list | fuzzel --dmenu --prompt="Add to Favourites ")
        if [ -n "$item" ]; then
            # Decode the item from clipboard history
            full_item=$(echo "$item" | cliphist decode)
            encoded_item=$(echo "$full_item" | base64 -w 0)

            # Check if the item is already in the favorites file
            if grep -Fxq "$encoded_item" "$favoritesFile"; then
                notify-send "Item is already in favorites."
            else
                # Add the encoded item to the favorites file
                echo "$encoded_item" >> "$favoritesFile"
                notify-send "Added in favorites."
            fi
        fi
        ;;
    "Remove from Favorites")
        if [ -f "$favoritesFile" ] && [ -s "$favoritesFile" ]; then
            # Read each Base64 encoded favorite as a separate line
            mapfile -t favorites < "$favoritesFile"

            # Prepare a list of decoded single-line representations for fuzzel
            decoded_lines=()
            for favorite in "${favorites[@]}"; do
                decoded_favorite=$(echo "$favorite" | base64 --decode)
                # Replace newlines with spaces for fuzzel display
                single_line_favorite=$(echo "$decoded_favorite" | tr '\n' ' ')
                decoded_lines+=("$single_line_favorite")
            done

            selected_favorite=$(printf "%s\n" "${decoded_lines[@]}" | fuzzel --dmenu --prompt="Remove from Favourites ")
            if [ -n "$selected_favorite" ]; then
                index=$(printf "%s\n" "${decoded_lines[@]}" | grep -nxF "$selected_favorite" | cut -d: -f1)
                if [ -n "$index" ]; then
                    selected_encoded_favorite="${favorites[$((index - 1))]}"

                    # Handle case where only one item is present
                    if [ "$(wc -l < "$favoritesFile")" -eq 1 ]; then
                        # Remove the single encoded item from the file
                        > "$favoritesFile"
                    else
                        # Remove the selected encoded item from the favorites file
                        grep -vF -x "$selected_encoded_favorite" "$favoritesFile" > "${favoritesFile}.tmp" && mv "${favoritesFile}.tmp" "$favoritesFile"
                    fi
                    notify-send "Item removed from favorites."
                else
                    notify-send "Error: Selected favorite not found."
                fi
            fi
        else
            notify-send "No favorites to remove."
        fi
        ;;
    "Clear All Favorites")
        if [ -f "$favoritesFile" ] && [ -s "$favoritesFile" ]; then
            confirm=$(echo -e "Yes\nNo" | fuzzel --dmenu --prompt="Clear all Favourites ")
            if [ "$confirm" = "Yes" ]; then
                > "$favoritesFile"
                notify-send "All favorites have been deleted."
            fi
        else
            notify-send "No favorites to delete."
        fi
        ;;
        *)
            echo "Invalid action"
            exit 1
            ;;
        esac
        ;;
"Clear History")
    if [ "$(echo -e "Yes\nNo" | fuzzel --dmenu --prompt="Clear History ")" == "Yes" ] ; then
        cliphist wipe
        notify-send "Clipboard history cleared."
    fi
    ;;
*)
    echo "Invalid action"
    exit 1
    ;;
esac
