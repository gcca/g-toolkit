if test (count $argv) -ne 0
  gtk-load-env $argv[1]
end

function gtk-load-env --description 'Load variables'
  if test -e $argv[1]
    source $argv[1]
  end
end

function gtk-load-var --description 'Load variable'
  set -gx $argv[1] $argv[2]
end

function gtk-check-variables --description 'Check variables'
  for name in \
      GTK_DB_HOST \
      GTK_DB_USERNAME \
      GTK_DB_NAME
    if not set -q $name
      echo "$name not set"
    end
  end
end

function gtk-data-table-export --description 'Export postgres table'
  argparse 'h/host=' 'd/db=' 'u/usr=' 'p/pwd=' 't/table=' -- $argv
  for name in _flag_host _flag_db _flag_usr _flag_pwd _flag_table
    if not set -q $name
      echo (string replace -r '^_flag_' '' $name) not set
      return 1
    end
  end
  echo Executing with host=$_flag_host db=$_flag_db usr=$_flag_usr pwd=$_flag_pwd table=$_flag_table
  env PGPASSWORD=$_flag_pwd pg_dump -h $_flag_host -d $_flag_db -U $_flag_usr -t $_flag_table --data-only
end

function gtk-data-table-import --description 'Import postgres table'
  argparse 'h/host=' 'd/db=' 'u/usr=' 'p/pwd=' 'f/file=' -- $argv
  for name in _flag_host _flag_db _flag_usr _flag_pwd _flag_file
    if not set -q $name
      echo (string replace -r '^_flag_' '' $name) not set
      return 1
    end
  end
  echo Executing with host=$_flag_host db=$_flag_db usr=$_flag_usr pwd=$_flag_pwd file=$_flag_file
  env PGPASSWORD=$_flag_pwd psql -h $_flag_host -U $_flag_usr -d $_flag_db -f $_flag_file
end
