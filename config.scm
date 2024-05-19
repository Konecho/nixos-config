(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (timezone "Australia/Sydney")
  (host-name "deskmini")
  (users (cons* (user-account
                 (name "mei")
                 (comment "Mei")
                 (group "users")
                 (home-directory "/home")
		;; Needed since /etc/passwd is not persisted.
		(password (crypt "password" "1234"))
                 (supplementary-groups
                  '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
   (append
    (list
     (specification->package "emacs-next"))
    %base-packages))
  (services
   (append
    (list (service gnome-desktop-service-type)
          (set-xorg-configuration
           (xorg-configuration
            (keyboard-layout keyboard-layout))))
    %desktop-services))
  (bootloader
   (bootloader-configuration
    (bootloader grub-bootloader)
    (target "/dev/disk/by-label/nixos")
    (keyboard-layout keyboard-layout)))
  (file-systems
   (cons* (file-system
           (mount-point "/")
           (device
	   ;; TODO: Raise bug that root-as-tmpfs falsely requires a partition.
            (uuid "59457d60-2b08-4f5c-b1c7-e29cd5f7a3da"
                  'btrfs))
	  (options "size=1G")
           (type "tmpfs"))

	 (file-system
	  (mount-point "/boot")
           (device
           ("uuid" "4944-6404"
           'fat))
	  (needed-for-boot? #t)
           (type "btrfs"))	

	 (file-system
	  (mount-point "/home")
           (device
           (file-system-label "nixos"
                  'btrfs))
	  (options "subvol=home")
           (type "btrfs"))

	 (file-system
	  (mount-point "/gnu")
           (device
            (file-system-label "nixos"
                  'btrfs))
	  (options "subvol=@gnu")
	  (needed-for-boot? #t)
           (type "btrfs"))

          %base-file-systems)))
