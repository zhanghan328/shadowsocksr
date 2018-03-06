#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 7+/Ubuntu 14.04+
#	Description: ShadowsocksR Port-IP Check
#	Version: 1.0.2
#	Author: Toyo
#=================================================
# ——————————————————————————————
IP_threshold=2
# IP阈值
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m"
Yellow_font_prefix="\033[33m" && Purple_font_prefix="\033[35m"
Sky_blue_font_prefix="\033[36m" && Blue_font_prefix="\033[34m"
Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
# ——————————————————————————————
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	#bit=`uname -m`
}
check_pid(){
	PID=`ps -ef |grep -v grep | grep server.py |awk '{print $2}'`
	[[ -z ${PID} ]] && echo -e "${Error} ShadowsocksR服务端没有运行，请检查 !" && exit 1
}
scan_port_centos(){
	port=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp' | grep '::ffff:' |awk '{print $4}' |awk -F ":" '{print $NF}' |sort -u`
	port_num=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp' | grep '::ffff:' |awk '{print $4}' |awk -F ":" '{print $NF}' |sort -u |wc -l`
	[[ -z ${port} ]] && echo -e "${Error} 没有发现正在链接的端口 !" && exit 1
	[[ ${port_num} = 0 ]] && echo -e "${Error} 没有发现正在链接的端口 !" && exit 1
}
scan_port_debian(){
	port=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp6' |awk '{print $4}' |awk -F ":" '{print $NF}' |sort -u`
	port_num=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp6' |awk '{print $4}' |awk -F ":" '{print $NF}' |sort -u |wc -l`
	[[ -z ${port} ]] && echo -e "${Error} 没有发现正在链接的端口 !" && exit 1
	[[ ${port_num} = 0 ]] && echo -e "${Error} 没有发现正在链接的端口 !" && exit 1
}
scan_ip_centos(){
	ip=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp' | grep '::ffff:' |awk '{print $5}' |awk -F ":" '{print $4}' |sort -u`
	ip_num=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp' | grep '::ffff:' |awk '{print $5}' |awk -F ":" '{print $4}' |sort -u |wc -l`
	[[ -z ${ip} ]] && echo -e "${Error} 没有发现正在链接的IP !" && exit 1
	[[ ${ip_num} = 0 ]] && echo -e "${Error} 没有发现正在链接的IP !" && exit 1
}
scan_ip_debian(){
	ip=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp6' |awk '{print $5}' |awk -F ":" '{print $1}' |sort -u`
	ip_num=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp6' |awk '{print $5}' |awk -F ":" '{print $1}' |sort -u |wc -l`
	[[ -z ${ip} ]] && echo -e "${Error} 没有发现正在链接的IP !" && exit 1
	[[ ${ip_num} = 0 ]] && echo -e "${Error} 没有发现正在链接的IP !" && exit 1
}
check_threshold_centos(){
	for((integer = ${port_num}; integer >= 1; integer--))
	do
		port_check=`echo ${port} |awk '{print $'"$integer"'}'`
		ip_check=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp' |grep "${port_check}" | grep '::ffff:' |awk '{print $5}' |awk -F ":" '{print $4}' |sort -u`
		ip_num=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp' |grep "${port_check}" | grep '::ffff:' |awk '{print $5}' |awk -F ":" '{print $4}' |sort -u |wc -l`
		ip_check=`echo ${ip_check}|sed 's/ / | /g'`
		[[ ${ip_num} -ge ${IP_threshold} ]] && echo -e " 端口: ${Red_font_prefix}${port_check}${Font_color_suffix} ,IP总数: ${Red_font_prefix}${ip_num}${Font_color_suffix} ,IP: ${Sky_blue_font_prefix}$(echo ${ip_check})${Font_color_suffix}"
	done
}
check_threshold_debian(){
	for((integer = ${port_num}; integer >= 1; integer--))
	do
		port_check=`echo ${port} |awk '{print $'"$integer"'}'`
		ip_check=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp6' |grep "${port_check}" |awk '{print $5}' |awk -F ":" '{print $1}' |sort -u`
		ip_num=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp6' |grep "${port_check}" |awk '{print $5}' |awk -F ":" '{print $1}' |sort -u |wc -l`
		ip_check=`echo ${ip_check}|sed 's/ / | /g'`
		[[ ${ip_num} -ge ${IP_threshold} ]] && echo -e " 端口: ${Red_font_prefix}${port_check}${Font_color_suffix} ,IP总数: ${Red_font_prefix}${ip_num}${Font_color_suffix} ,IP: ${Sky_blue_font_prefix}$(echo ${ip_check})${Font_color_suffix}"
	done
}
c_ssr(){
	check_pid
	if [[ ${release} == "centos" ]]; then
		scan_port_centos
		echo -e "当前时间：${Yellow_font_prefix}$(date "+%Y-%m-%d %H:%I:%S %u %Z")${Font_color_suffix}\n"
		check_threshold_centos
	else
		scan_port_debian
		echo -e "当前时间：${Yellow_font_prefix}$(date "+%Y-%m-%d %H:%I:%S %u %Z")${Font_color_suffix}\n"
		check_threshold_debian
	fi
}
a_ssr(){
	check_pid
	IP_threshold=1
	if [[ ${release} == "centos" ]]; then
		scan_port_centos
		scan_ip_centos
		echo -e "当前时间：${Yellow_font_prefix}$(date "+%Y-%m-%d %H:%I:%S %u %Z")${Font_color_suffix} ,当前链接的端口共 ${Red_font_prefix}${port_num}${Font_color_suffix} ,当前链接的IP共 ${Red_font_prefix}${ip_num}${Font_color_suffix} \n"
		check_threshold_centos
	else
		scan_port_debian
		scan_ip_debian
		echo -e "当前时间：${Yellow_font_prefix}$(date "+%Y-%m-%d %H:%I:%S %u %Z")${Font_color_suffix} ,当前链接的端口共 ${Red_font_prefix}${port_num}${Font_color_suffix} ,当前链接的IP共 ${Red_font_prefix}${ip_num}${Font_color_suffix} \n"
		check_threshold_debian
	fi
	
}
check_sys
[[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && [[ ${release} != "centos" ]] && echo -e "${Error} 本脚本不支持当前系统 ${release} !" && exit 1
action=$1
[[ -z $1 ]] && action=c
case "$action" in
    c|a)
    ${action}_ssr
    ;;
    *)
    echo -e "输入错误 !
 用法: 
 c 检查并显示 超过IP阈值的端口
 a 显示当前 所有端口IP连接信息"
    ;;
esac
