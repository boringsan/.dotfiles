(use-modules
 (gnu home services shells)
 (gnu home services)
 (gnu home)
 (gnu packages version-control)
 (gnu packages)
 (gnu services)
 (guix gexp))

(home-environment
 (packages
  (map specification->package
       (list "git"
             "gitolite")))
 (services
  (list
   (service home-bash-service-type
            (home-bash-configuration
             (bashrc
              (list
               ;; this is for sshd to eval before running gitolite-shell
               (plain-file "init-bashrc" "PATH=$HOME/.guix-home/profile/bin")))))
   (simple-service
    'gitolite-rebuild-hooks
    home-activation-service-type
    #~(system* #$(file-append gitolite "/bin/gitolite") "setup" "--hooks-only")))))
