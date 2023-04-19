{
  description = "Gandalf";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:chvp/devshell";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, nixpkgs, devshell, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ devshell.overlays.default ]; };
      in
      {
        devShells = rec {
          default = gandalf;
          gandalf = pkgs.devshell.mkShell {
            name = "Gandalf";
            imports = [
              "${devshell}/extra/language/ruby.nix"
              "${devshell}/extra/git/hooks.nix"
            ];
            git.hooks = {
              enable = true;
              pre-commit = {
                text = "bundle exec rubocop";
              };
            };
            packages = with pkgs; [
              docker
              nodejs
              libyaml
              imagemagick
            ];
            language.ruby = {
              package = pkgs.ruby_3_2;
              nativeDeps = [ pkgs.libmysqlclient pkgs.zlib ];
            };
            env = [
              {
                name = "DATABASE_ROOT_PASSWORD";
                eval = "gandalf";
              }
              {
                name = "TEST_DATABASE_URL";
                eval = "mysql2://root:gandalf@127.0.0.1:3306/gandalf_test";
              }
              {
                name = "DATABASE_URL";
                eval = "mysql2://root:gandalf@127.0.0.1:3306/gandalf";
              }
            ];
            serviceGroups.server.services = {
              rails = {
                name = "server";
                command = "rails db:prepare && rails s -p 3000";
              };
              mysql.command = "mysql";
              redis.command = "redis-server --port 6379";
              sidekiq.command = "bundle exec sidekiq";
            };
            commands = [
              {
                name = "gems:refresh";
                category = "general commands";
                help = "Install dependencies";
                command = ''
                  bundle install
                  bundle pristine
                '';
              }
              {
                name = "mysql";
                category = "database";
                help = "Start database docker";
                command = ''
                  trap "systemd-run --user docker stop gandalf-db" 0
                  docker run --name gandalf-db -p 3306:3306 --rm -v gandalf-db-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=$DATABASE_ROOT_PASSWORD mariadb:latest &
                  wait
                '';
              }
              {
                name = "mysql-console";
                category = "database";
                help = "Open database console";
                command = ''
                  docker exec -i gandalf-db mysql -uroot -p"$DATABASE_ROOT_PASSWORD"
                '';
              }
              {
                name = "redis";
                package = pkgs.redis;
              }
            ];
          };
        };
      }
    );
}
