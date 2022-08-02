#!/usr/bin/env bash
#Title          : linux_srv_status.bash
#Description    : To check linux server status
#Author         : Santosh Kulkarni
#Date           : 02-Aug-2022 16-10
#Version        : 2.8.2 
#Usage          : ./linux_srv_status.bash
#Notes:         created by santosh kulkarni
#Tested on Bash Version: 4.2.46(2)-release
#Mail ID:       santosh.kulkarni4u@gmail.com
#
# shellcheck disable=SC2034
utility_version="2.8.2"
# shellcheck disable=SC2034
utility_release_date_13_carector="02 August 2022"
# shellcheck disable=SC2034
scriptName=$( basename "$0" )
# shellcheck disable=SC2034
scriptName_with_full_path=$( realpath "$0" )
# shellcheck disable=SC2034
script_dir=$(dirname  "$(readlink -f  "$0")")
# shellcheck disable=SC2034
script_dir_only_name=$(basename "$script_dir" )
# shellcheck disable=SC2034
date_and_time_stamp="$(date '+%d-%h-%y_%H_%M')"
# shellcheck disable=SC2034
utility_name_30_caractor="Linux server performance status script"
# shellcheck disable=SC2034
utility_name_space_removed="${utility_name_30_caractor// /}"
# shellcheck disable=SC2034
Temp_dir="$script_dir/Temp"
# shellcheck disable=SC2034
Logs_dir="$script_dir/Logs"
# shellcheck disable=SC2034
Runcontrl_dir="/tmp/$utility_name_space_removed"
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
# Uncomment Following line if Standerd Error and Standerd output is thron on following Line 
# exec >log_${date_and_time_stamp}.txt 2>&1
#--------------------------------------------------------------------------------------------------#
############################### Global Array Declaration Section Started ###########################
#--------------------------------------------------------------------------------------------------#
# Declare packages you want to check before running the script.
# Use below function to check the packages 
# check_binary_with_check_packges_before_arrey_function "check_packges_before_arrey" or  "package name to check"
declare -a check_packges_before_arrey=( sudo yum  not_exist_package)
#
# 
#--------------------------------------------------------------------------------------------------#
############################### Global Array Declaration Section Ended #############################
#--------------------------------------------------------------------------------------------------#
# 
# 
#--------------------------------------------------------------------------------------------------#
############################# Global Function  Section Started #####################################
#--------------------------------------------------------------------------------------------------#
#
# The following function prints a text using custom color
# -c or --color define the color for the print. See the array colors for the available options.
# -n or --noline directs the system not to print a new line after the content.
# Last argument is the message to be printed.
function cecho_function () 
{
    # 
    declare -A colors;
    colors=(\
        ['black']='\E[0;47m'\
        ['red']='\E[0;31m'\
        ['green']='\E[0;32m'\
        ['yellow']='\E[0;33m'\
        ['blue']='\E[0;34m'\
        ['magenta']='\E[0;35m'\
        ['cyan']='\E[0;36m'\
        ['white']='\E[0;37m'\
    );
    # 
    local defaultMSG="No message passed.";
    local defaultColor="black";
    local defaultNewLine=true ;
    # 
    while [[ $# -gt 1 ]];
    do
    key="$1";
    # 
    case $key in
        -c|--color)
            color="$2";
            shift;
        ;;
        -n|--noline)
            newLine=false;
        ;;
        *)
            # unknown option
        ;;
    esac
    shift;
    done
    # 
    message=${1:-$defaultMSG};   # Defaults to default message.
    color=${color:-$defaultColor};   # Defaults to default color, if not specified.
    newLine=${newLine:-$defaultNewLine};
    # 
    echo -en "${colors[$color]}";
    echo -en "$message";
    if [ "$newLine" = true ] ; then
        echo;
    fi
    tput sgr0; #  Reset text attributes to normal without clearing screen.
    # 
    return;
    # 
}
# 
#--------------------------------------------------------------------------------------------------#
# 
function load_version_file_function ()
{
Version_File="/tmp/.Version_info.txt"

if [[ -f $Version_File ]]; then
        #statements
    cat "$Version_File"
else 
cat << EOF > "$Version_File"
#
|==========================================================|
| ${utility_name_30_caractor} | Version: ${utility_version}  |
|==========================================================|
| Developed by: Santosh Kulkarni | Linux System Admin      |
|----------------------------------------------------------|
| Released Date: ${utility_release_date_13_carector}                            |
|----------------------------------------------------------|
| Mail: santosh.kulkarni4u@gmail.com | Cell:+91 9960708564 |
|----------------------------------------------------------|
| Git: https://github.com/santosh2712/linux_srv_status.git |
|==========================================================|    
#
EOF
#
load_version_file_function
#
fi
}
# 
#--------------------------------------------------------------------------------------------------#
# 
function check_version_file_integrity_function () 
{
        check_version_file_integrity_function_with_hash=false
        local correct_md5sum="688b433c3cd5811e9bd0eb9d8bd0a3e5"
        local current_version_file_md5sum
        current_version_file_md5sum=$(md5sum "$Version_File" | cut -f 1 )
        if [[ ${check_version_file_integrity_function_with_hash,,} == "true" ]] ; then
            # 
            if [[ "$current_version_file_md5sum"  == "$correct_md5sum" ]]; then
                # 
                info_msg "Version file integrity check OK"
                # 
            else 
                # 
                error_msg "Version_File is changed. Incorrect modification Exiting script"
                exit 1     
                # 
            fi 
            # 
        fi
}
#
#--------------------------------------------------------------------------------------------------#
#
function load_conf_file_function ()
{
    # 
    external_conf_file_1="$script_dir/external_conf_file_1.conf"
    # 
    if [[ -f "$external_conf_file_1"  ]]; then
        # shellcheck disable=SC1090
        source "$external_conf_file_1"
        # 
        draw_line_function - white 50
        info_msg "Conf file $external_conf_file_1 is loaded"
        draw_line_function - white 50
        # 
    else 
        # 
        draw_line_function - white 50
        error_msg "WARN: $external_conf_file_1 file not found exiting "
        draw_line_function - white 50
        exit 1     
        # 
    fi
    # 
}
# 
#--------------------------------------------------------------------------------------------------#
# 

# 
###############################################
# 
# for i in p098as01 p098as02 p098db01 p098db02 k098ps01 k098ps02  p098bk ; do
#         #statements
#         draw_line_function
#         __get_remote_server_role_bash_function $i 
#         draw_line_function
# done
# 
#
# 
#--------------------------------------------------------------------------------------------------#
# 
black () {
# 
    cecho_function -c 'black' "$@";
}
red () {
# 
    cecho_function -c 'red' "$@";
}
green () {
# 
    cecho_function -c 'green' "$@";
}
yellow () {
# 
    cecho_function -c 'yellow' "$@";
}
blue () {
# 
    cecho_function -c 'blue' "$@";
}
magenta () {
# 
    cecho_function -c 'magenta' "$@";
}
cyan () {
# 
    cecho_function -c 'cyan' "$@";
}
white () {
# 
    cecho_function -c 'white' "$@";
}
# 
info_msg () {
# 
    cecho_function -c 'green' "[INFO]: $*";
}
# 
warn_msg () {
# 
    cecho_function -c 'blue' "[WARN]: $*";
}
# 
error_msg () {
# 
    cecho_function -c 'red' "[ERROR]: $*";
}
# 
#--------------------------------------------------------------------------------------------------#
#
function check_binary()
{
# 
    if [[ $# -lt 1 ]]; then
        error_msg 'Missing required argument to check_binary()!' 2
    fi
    # 
    if ! command -v "$1" > /dev/null 2>&1; then
        if [[ -n ${2-} ]]; then
            error_msg "Missing dependency: Couldn't locate $1." 1
            draw_line_function - white 50
        else
            error_msg "Missing dependency: $1"
            draw_line_function - white 50
            return 1
        fi
    fi
    # 
    info_msg "Found Package Installed : $1"
    draw_line_function - white 50
    return 0
#
}
#
#--------------------------------------------------------------------------------------------------#
#
function check_binary_with_check_packges_before_arrey_function ()
{
#
for Pkg in "${check_packges_before_arrey[@]}"; do
    #statements
    # shellcheck disable=SC2086
    check_binary $Pkg
done
}
#
#--------------------------------------------------------------------------------------------------#
#
# DESC: Run the requested command as root (via sudo if requested)
# ARGS: $1 (optional): Set to zero to not attempt execution via sudo
#       $@ (required): Passed through for execution as root user
# OUTS: None
function run_as_root_function() 
{
    if [[ $# -eq 0 ]]; then
        white 'Missing required argument to run_as_root_function()!' 2
    fi
    # 
    if [[ ${1-} =~ ^0$ ]]; then
        local skip_sudo=true
        shift
    fi
    # 
    if [[ $EUID -eq 0 ]]; then
        "$@"
    elif [[ -z ${skip_sudo-} ]]; then
        sudo -H -- "$@"
    else
        white "Unable to run requested command as root: $*" 1
    fi
}
# 
#--------------------------------------------------------------------------------------------------#
# 
# DESC: Validate we have superuser access as root (via sudo if requested)
# ARGS: $1 (optional): Set to any value to not attempt root access via sudo
# OUTS: None
# 
# shellcheck disable=SC2120
function check_superuser_function() 
{
    local superuser
    if [[ $EUID -eq 0 ]]; then
        superuser=true
    elif [[ -z ${1-} ]]; then
        if check_binary sudo; then
            white 'Sudo: Updating cached credentials ...'
            if ! sudo -v; then
                # 
                red "Sudo: Couldn't acquire credentials ..." 
                # 
            else
                local test_euid
                test_euid="$(sudo -H -- "$BASH" -c 'printf "%s" "$EUID"')"
                if [[ $test_euid -eq 0 ]]; then
                    superuser=true
                fi
            fi
        fi
    fi
#
    if [[ -z ${superuser-} ]]; then
        red 'Unable to acquire superuser credentials.' #"${fg_red-}"
        return 1
    fi
    #
    green 'Successfully acquired superuser credentials.'
    return 0
    # 
}
# 
#--------------------------------------------------------------------------------------------------#
# 
draw_line_function ()
{
local default_carector_to_print
default_carector_to_print=${1:--}
local line_colour_default
line_colour_default=${2:- white}
local default_carector_lenth_to_print
default_carector_lenth_to_print=${3:-$(tput cols)}
# echo "default_carector_to_print:$default_carector_to_print line_colour_default:$line_colour_default default_carector_lenth_to_print:$default_carector_lenth_to_print "
$line_colour_default "$(printf %"$default_carector_lenth_to_print"s | tr " " "$default_carector_to_print" )"
# 
# Usage:
# Warm: dont use \ as default_carector_to_print
# function_name <default_carector_to_print> <Colour> <default_carector_lenth_to_print>
# draw_line_function = cyan
# draw_line_function = white 50 
}
# 
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
# 
function __new_create_directors_function ()
{
    # 
    array_to_create_directory=("$@")
    # 
    declare -i array_to_create_directory_elements_count=${#array_to_create_directory[@]}
    #
    # shellcheck disable=SC2086
    if [ $array_to_create_directory_elements_count -ge 1 ]; then
        #statements
        # echo "array is ${array_to_create_directory[@]}"
        for Dir in "${array_to_create_directory[@]}" ; do
            #statements
            [[ -d "$Dir" ]] || mkdir -p "$Dir"
        done
    else 
        warn_msg "__new_create_directors_function function required arguments"    
    fi
    #_____________________________________________________________
    # Usage
    # Function Name "${array_anme[@]"
    # Example 
    # __new_create_directors_function ${dir_arrey[@]}
    #_____________________________________________________________
    # 
}
# 
#--------------------------------------------------------------------------------------------------#
# 
function Check_Run_Control () 
{
    if [[ -d $Runcontrl_dir ]]; then
        #statements
        red "Another Instance of the script $scriptName is may be Running as $Runcontrl_dir directory is present"
        exit 1 
    else
        [[ -d $Runcontrl_dir ]] || mkdir -p "$Runcontrl_dir"      
    fi
}
# 
#--------------------------------------------------------------------------------------------------#
# 
# Printing colour with tput 
colorprintf_function () 
{
    case $1 in
        "black") tput setaf 0;;
        "red") tput  setaf 1;;
        "green") tput setaf 2;;
        "orange") tput setaf 3;;
        "blue") tput setaf 4;;
        "purple") tput setaf 5;;
        "cyan") tput setaf 6;;
        "white") tput setaf 7;;
        "gray" | "grey") tput setaf 8;;
    esac
    # printf "%s\n" "$2"  
    printf "%s\n" "$2" 
    tput sgr0
    wait 
    # 
    # Usage: 
    # colorprintf_function red "This is sample test in red "
}
# 
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
# 
# print usage information
function _echo_usage 
{
  echo 'USAGE:'
  echo "bm -h                   - Prints this usage info"
  echo 'bm -a <bookmark_name>   - Saves the current directory as "bookmark_name"'
  echo 'bm [-g] <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"'
  echo 'bm -p <bookmark_name>   - Prints the directory associated with "bookmark_name"'
  echo 'bm -d <bookmark_name>   - Deletes the bookmark'
  echo 'bm -l                   - Lists all available bookmarks'
}
#
#--------------------------------------------------------------------------------------------------#
# 
#--------------------------------------------------------------------------------------------------#
############################# Global Function  Section Ended #######################################
#--------------------------------------------------------------------------------------------------#
#
#
#
#==================================================================================================#
# Running Script : Script Body section started  
#==================================================================================================#
rm -f /tmp/.Version_info.txt
load_version_file_function
white "script_dir:$script_dir"
white "Runcontrl_dir:$Runcontrl_dir"
white "scriptName:$scriptName"
white "scriptName_with_full_path:$scriptName_with_full_path"
white "script_dir_only_name:$script_dir_only_name"
colorprintf_function cyan "colorprintf_function cyan: This cyan is using colorprintf_function function"
#
red "This red is using cecho_function function"
#
# message
#
draw_line_function _ green 40
check_binary_with_check_packges_before_arrey_function
draw_line_function _ green 40
# Running Command as root 
run_as_root_function id  
# checking weather super user permission is available
check_superuser_function
draw_line_function
#
# Clearing Runcontrl_dir dir if exist
[[ -d "$Runcontrl_dir" ]] && rm -rf "$Runcontrl_dir"
#
#==================================================================================================#
# Running Script : Script Body section Ended  
#==================================================================================================#
# 
