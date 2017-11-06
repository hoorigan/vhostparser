#!/bin/bash

file_config="${1}";
file_config_short="$(mktemp vhosts_XXXXX.tmp)";

function reset_variables() {
  host_ips="";
  host_name="";
  host_aliases="";
  out_line="";
}

function unset_variables() {
  unset host_ips;
  unset host_name;
  unset host_aliases;
  unset out_line;
}

reset_variables;

grep -iP '(VirtualHost|Server(Name|Alias)|DocumentRoot)' ${file_config} > ${file_config_short};

cat ${file_config_short} | grep -vP '^( |       )+?$' | while read line; do
  if [[ ${line} =~ \<VirtualHost\ .*\> ]]; then
    host_ips=$(echo ${line} | perl -pe 's#(<VirtualHost |>)##g' | perl -pe 's# #,#g');
  elif [[ ${line} =~ ServerName\ .* ]]; then
    host_name=$(echo ${line} | perl -pe 's#ServerName ##g');
  elif [[ ${line} =~ ServerAlias\ .* ]]; then
    if [[ ${host_aliases} == "" ]]; then
      host_aliases=$(echo ${line} | perl -pe 's#ServerAlias ##g' | perl -pe 's# #,#g');
    else
      host_aliases+=",$(echo ${line} | perl -pe 's#ServerAlias ##g' | perl -pe 's# #,#g')";
    fi
  elif [[ ${line} =~ DocumentRoot\ .* ]]; then
    host_root=$(echo ${line} | perl -pe 's#DocumentRoot ##g');
  elif [[ ${line} =~ \</VirtualHost\> ]]; then
    out_line="${host_ips} ${host_name} ${host_aliases} ${host_root}";
    echo ${out_line};
    reset_variables;
  else
    echo "vhostparser: caught bad line: '${line}'"
    unset_variables;
    exit 1;
  fi;
done

rm ${file_config_short};

exit 0;
