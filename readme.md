![nvim config](image.png)

# Keybinds

## General

Leader key (LDR) = space

### Insert mode

* LDR-d - Opens floating diagnostic window -> usefull to see long error messages

### Visual mode

* C-space - Init selection + Node incremental selection
* S-space - Node decremental selection

## Plugin keybinds

### Telescope

* LDR-LDR - Opens the find files telescope window
    * LDR-sf - Alias. Mnemonic: [S]earch [F]iles
* LDR-ss - Opens the live grep window. Mnemonic: [S]earch [S]tring(s)
* LDR-sb - Fuzy search in the current buffer. Mnemonic: [S]earch in current [B]uffer
* LDR-rf - Opens the recent files window. Mnemonic [R]ecent [F]iles
    * LDR-e - Alias.
* LDR-gr - Opens the LSP references window. Mnemonic: [G]oto [R]eferences
* LDR-b - Opens the buffers list. Mnemonic: See [B]uffers

### Undo Tree

* LDR-u - Opens undo tree

### Fugitive (Git wrapper)

* LDR-vc - Opens the fugitive window. Mnemonic: [V]ersion [C]control


### LSP

* LDR-rn - Rename symbol. Mnemonic: [R]e[n]ame
* LDR-ca - Mnemonic: [C]ode [A]ction
* LDR-gi - Go to implementation. Mnemonic: [G]oto [I]mplementation
* LDR-d -  Opens the documentation for the text under the cursor Mnemonic: Hover Documentation
* LDR-sd - Opens the signature docs. Mnemonic: Signature [D]ocumentation