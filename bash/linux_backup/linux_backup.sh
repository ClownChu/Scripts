#!/bin/bash

# ClownChu Scripts - https://github.com/ClownChu/Scripts
# Copyright (C) 2023 Vitor de Souza (vitordesouza@hotmail.com.br)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY| without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

LOG_TAG="ClownChu/bash/${0}"

DB_PASSWORD=$1
BACKUP_PATH=$2
FULL_BACKUP_DAY=$3 # Mon = 1| Sun = 7
MAX_BACKUPS=$4
RCLONE_REMOTE_NAME=$5
RCLONE_REMOTE_CONTAINER=$6
VERBOSE=$7

if ([ ! -d "$BACKUP_PATH" ]) then
  `mkdir -p "${BACKUP_PATH}"`
fi

UMASK="umask"
umask 0077

TAR_OPTIONS="-czf"
RCLONE_OPTIONS=""
if ([ "$VERBOSE" == "true" ]) then
  TAR_OPTIONS="-czvf"
  RCLONE_OPTIONS="-P"
fi

TODAY=`date +%Y-%m-%d`
WEEK_DAY=`date +%u`

# ({path};{output};{full|lite};{exclude})
declare -a PATHS_TO_BACKUP
PATHS_TO_BACKUP[0]="/usr;usr;lite;src,share,X11R6,lost+found,tmp,x86_64-suse-linux"
PATHS_TO_BACKUP[1]="/var;var;lite;adm/autoinstall/cache,adm/backup,adm/mount,adm/YaST/InstSrcManager,cache,games,X11R6,lost+found,lib/clamav,lib/named/proc,lib/ntp/drift,lib/ntp/proc,lib/ntp/var,lib/zypp,lock,backup/system,log,run,spool/amavis/tmp,tmp"
PATHS_TO_BACKUP[2]="/;system;full;vz,backups,dev,media,data,mnt,proc,sys,srv,tmp,usr,var,root/.cpan,root/backup,home"

# ({database};{output};{full|lite})
declare -a DBS_TO_BACKUP
DBS_TO_BACKUP[0]="--all-databases;complete_mysql;lite"

write_log() {
    logger -d -t $LOG_TAG "${1}"

    if ([ "$VERBOSE" == "true" ]) then
      echo "${1}"
    fi
}

get_excludes_out() {
    IFS=',' read -ra exclude_arr <<< "$2"

    eval "$3=''"
    for i in "${exclude_arr[@]}"; do
        eval "$3+=' --exclude=${1}/${i}'"
    done
}

get_execution_stats() {
    end_date=`date +%s`
    
    total_runtime=$((${end_date}-${1}))

    write_log " "
    if ([ "$2" == "" ]) then
        write_log "Backup: ${total_runtime} seconds"
    else
        size=`ls -lh --si "${2}"|cut -d" " -f5`
        write_log "Backup: ${total_runtime} seconds (size: "${size}")"
    fi
}

file_system_backup() {
    for i in "${PATHS_TO_BACKUP[@]}"; do
        start_date=`date +%s`
        IFS=";" read -ra info <<< "$i"

        output_path="${BACKUP_PATH}/${TODAY}_${WEEK_DAY}_${info[1]}.tar.gz"

        write_log "File system backup - ${info[0]} | output: ${output_path}"
        if ([ "${info[2]}" == "full" ] && [ $WEEK_DAY != $FULL_BACKUP_DAY ]) then
            write_log "No full backup today"
            continue
        fi

        excludes_string=''
        get_excludes_out "${info[0]}" "${info[3]}" excludes_string
        
        if ([ "$VERBOSE" == "true" ]) then
          echo "tar ${excludes_string:1} ${TAR_OPTIONS} ${output_path} ${info[0]} 2>&1 1>&0"
        fi

        `tar ${excludes_string:1} ${TAR_OPTIONS} ${output_path} ${info[0]} 2>&1 1>&0`
        get_execution_stats $start_date $output_path
    done
}

db_backup() {
    for i in "${DBS_TO_BACKUP[@]}"; do
        IFS=';' read -ra info <<< "$i"

        output_path="${BACKUP_PATH}/${TODAY}_${WEEK_DAY}_${info[1]}.sql.gz"
        write_log "MySQL DB backup - ${info[0]} | output: ${output_path}"

        if ([ "${info[2]}" == "full" ] && [ $WEEK_DAY != $FULL_BACKUP_DAY ]) then
            write_log "No full backup today"
            continue
        fi

        start_date=`date +%s`

        if ([ "$VERBOSE" == "true" ]) then
          echo "mysqldump ${info[0]} --add-drop-table -p******* | gzip > ${output_path}"
        fi

        `mysqldump ${info[0]} --add-drop-table -p${DB_PASSWORD} 2>&1 1>&0 | gzip > ${output_path}`
        get_execution_stats $start_date $output_path
    done
}

delete_backups() {
    start_date=`date +%s`

    for i in "${PATHS_TO_BACKUP[@]}"; do
        IFS=";" read -ra ADDR <<< "$i"

        num_backups=`find ${BACKUP_PATH} -maxdepth 1 -type f | grep ".*_${ADDR[1]}.tar.gz" | wc -l`
        write_log "There are ${num_backups} backups available for: '.*_${ADDR[1]}.tar.gz' (Limit = ${MAX_BACKUPS})"

        while ([ $num_backups -gt $MAX_BACKUPS ]) do
            backup_file=`find ${BACKUP_PATH} -maxdepth 1 -type f | grep ".*_${ADDR[1]}.tar.gz" | sort | head -n 1`

            write_log "Deleting File System backup file: ${backup_file}"
            rm $backup_file

            num_backups=`find ${BACKUP_PATH} -maxdepth 1 -type f | grep ".*_${ADDR[1]}.tar.gz" | wc -l`
        done
    done

    for i in "${DBS_TO_BACKUP[@]}"; do
        IFS=";" read -ra ADDR <<< "$i"

        num_backups=`find ${BACKUP_PATH} -maxdepth 1 -type f | grep ".*_${ADDR[1]}.sql.gz" | wc -l`
        write_log "There are ${num_backups} backups available for: '.*_${ADDR[1]}.sql.gz' (Limit = ${MAX_BACKUPS})"

        while ([ $num_backups -gt $MAX_BACKUPS ]) do
            backup_file=`find ${BACKUP_PATH} -maxdepth 1 -type f | grep ".*_${ADDR[1]}.sql.gz" | sort | head -n 1`

            write_log "Deleting MySQL DB backup file: ${backup_file}"
            rm $backup_file

            num_backups=`find ${BACKUP_PATH} -maxdepth 1 -type f | grep ".*_${ADDR[1]}.sql.gz" | wc -l`
        done
    done

    get_execution_stats $start_date ""
}

sync_with_cloud() {
    if ([ "${RCLONE_REMOTE_NAME}" != "" ]) then
        if ([ "$VERBOSE" == "true" ]) then
          echo "rclone sync ${BACKUP_PATH} ${RCLONE_REMOTE_NAME}:${RCLONE_REMOTE_CONTAINER} ${RCLONE_OPTIONS} 2>&1 1>&0"
        fi

        `rclone sync ${BACKUP_PATH} ${RCLONE_REMOTE_NAME}:${RCLONE_REMOTE_CONTAINER} ${RCLONE_OPTIONS} 2>&1 1>&0`
    fi
}

SCRIPT_START_DATE=`date +%s`
write_log "Backup $(date +%Y-%m-%d\ %T) (${WEEK_DAY}) - START"

file_system_backup
db_backup

delete_backups

sync_with_cloud

get_execution_stats $SCRIPT_START_DATE ""
write_log "Backup $(date +%Y-%m-%d\ %T) (${WEEK_DAY}) - END"

exit 0