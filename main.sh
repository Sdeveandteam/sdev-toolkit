#!/bin/bash

MERAH='\033[0;31m'
HIJAU='\033[0;32m'
KUNING='\033[0;33m'
BIRU='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

tampilkan_banner() {
    clear
    echo -e "${CYAN}=====================================================${NC}"
    echo -e "${PURPLE}  ███╗   ██╗███╗   ███╗ █████╗ ██████╗     ${MERAH}██╗  ██╗${NC}"
    echo -e "${PURPLE}  ████╗  ██║████╗ ████║██╔══██╗██╔══██╗    ${MERAH}╚██╗██╔╝${NC}"
    echo -e "${PURPLE}  ██╔██╗ ██║██╔████╔██║███████║██████╔╝     ${MERAH}╚███╔╝ ${NC}"
    echo -e "${PURPLE}  ██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝      ${MERAH}██╔██╗ ${NC}"
    echo -e "${PURPLE}  ██║ ╚████║██║ ╚═╝ ██║██║  ██║██║          ${MERAH}██╔╝ ██╗${NC}"
    echo -e "${PURPLE}  ╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝          ${MERAH}╚═╝  ╚═╝${NC}"
    echo -e "${CYAN}=====================================================${NC}"
    echo -e "         ${HIJAU}MULTI-SCANNER TOOLKIT FOR LAB PROJECT${NC}"
    echo -e "             ${KUNING}[ Code by: sdev ]${NC}"
    echo -e "${CYAN}=====================================================${NC}"
    echo ""
}

menu_nmap() {
    while true; do
        tampilkan_banner
        echo -e "${HIJAU}[ SUB-MENU: NMAP NETWORK SCANNER ]${NC}"
        echo -e "${CYAN}1.${NC} Ping Scan (Cek Host Aktif)"
        echo -e "${CYAN}2.${NC} Fast Scan (Scan 100 Port Teratas)"
        echo -e "${CYAN}3.${NC} Service & Version Detection"
        echo -e "${CYAN}4.${NC} OS Detection (Butuh Root/Sudo)"
        echo -e "${CYAN}5.${NC} Aggressive Scan (Komplit)"
        echo -e "${CYAN}6.${NC} Kembali ke Menu Utama"
        echo ""
        echo -n -e "${KUNING}sdev-nmap > ${NC}"
        read pil_nmap

        if [ "$pil_nmap" -eq 6 ]; then
            break
        fi

        echo -n -e "${KUNING}[?] Masukkan IP Target / Domain: ${NC}"
        read target

        if [ -z "$target" ]; then
            echo -e "${MERAH}[!] Target tidak boleh kosong!${NC}"
            read
            continue
        fi

        echo -e "\n${HIJAU}[*] Menjalankan Nmap pada: $target ...${NC}\n"
        case $pil_nmap in
            1) nmap -sn "$target" ;;
            2) nmap -F "$target" ;;
            3) nmap -sV "$target" ;;
            4)
                if [ "$PREFIX" = "/data/data/com.termux/files/usr" ]; then
                    nmap -O "$target"
                else
                    sudo nmap -O "$target"
                fi
                ;;
            5) nmap -A "$target" ;;
            *) echo -e "${MERAH}[!] Pilihan tidak valid!${NC}" ;;
        esac
        echo -e "\n${KUNING}[*] Selesai. Tekan ENTER...${NC}"
        read
    done
}

menu_sqlmap() {
    if ! command -v sqlmap &> /dev/null; then
        tampilkan_banner
        echo -e "${MERAH}[!] Error: Sqlmap belum terinstall.${NC}"
        echo -e "${KUNING}[*] Install via Termux: pkg install sqlmap${NC}"
        echo -e "${KUNING}[*] Install via Linux : sudo apt install sqlmap${NC}"
        echo -e "\nTekan ENTER untuk kembali..."
        read
        return
    fi

    while true; do
        tampilkan_banner
        echo -e "${HIJAU}[ SUB-MENU: SQLMAP SQLi SCANNER ]${NC}"
        echo -e "${CYAN}1.${NC} Cek Kerentanan URL Dasar"
        echo -e "${CYAN}2.${NC} Scan & Cari Nama Database (--dbs)"
        echo -e "${CYAN}3.${NC} Scan Tabel dari Database Spesifik"
        echo -e "${CYAN}4.${NC} Dump Data dari Tabel Spesifik"
        echo -e "${CYAN}5.${NC} Kembali ke Menu Utama"
        echo ""
        echo -n -e "${KUNING}sdev-sqlmap > ${NC}"
        read pil_sql

        if [ "$pil_sql" -eq 5 ]; then
            break
        fi

        echo -n -e "${KUNING}[?] Masukkan URL Target (cth: http://target.com/page.php?id=1): ${NC}"
        read url

        if [ -z "$url" ]; then
            echo -e "${MERAH}[!] URL tidak boleh kosong!${NC}"
            read
            continue
        fi

        case $pil_sql in
            1)
                echo -e "\n${HIJAU}[*] Memeriksa celah SQLi...${NC}\n"
                sqlmap -u "$url" --batch
                ;;
            2)
                echo -e "\n${HIJAU}[*] Mencari daftar database...${NC}\n"
                sqlmap -u "$url" --dbs --batch
                ;;
            3)
                echo -n -e "${KUNING}[?] Masukkan Nama Database: ${NC}"
                read db_name
                echo -e "\n${HIJAU}[*] Mencari tabel di db $db_name...${NC}\n"
                sqlmap -u "$url" -D "$db_name" --tables --batch
                ;;
            4)
                echo -n -e "${KUNING}[?] Masukkan Nama Database: ${NC}"
                read db_name
                echo -n -e "${KUNING}[?] Masukkan Nama Tabel: ${NC}"
                read table_name
                echo -e "\n${HIJAU}[*] Memulai dump data...${NC}\n"
                sqlmap -u "$url" -D "$db_name" -T "$table_name" --dump --batch
                ;;
            *)
                echo -e "${MERAH}[!] Pilihan tidak valid!${NC}"
                ;;
        esac
        echo -e "\n${KUNING}[*] Selesai. Tekan ENTER...${NC}"
        read
    done
}

menu_sqldump() {
    while true; do
        tampilkan_banner
        echo -e "${HIJAU}[ SUB-MENU: SQL DATABASE BACKUP / DUMP ]${NC}"
        echo -e "${CYAN}1.${NC} Backup/Dump Database MySQL Remote"
        echo -e "${CYAN}2.${NC} Kembali ke Menu Utama"
        echo ""
        echo -n -e "${KUNING}sdev-sqldump > ${NC}"
        read pil_dump

        if [ "$pil_dump" -eq 2 ]; then
            break
        fi

        if ! command -v mysqldump &> /dev/null; then
            echo -e "${MERAH}[!] Error: mysqldump belum terinstall.${NC}"
            echo -e "${KUNING}[*] Install via Termux: pkg install mariadb${NC}"
            echo -e "${KUNING}[*] Install via Linux : sudo apt install mysql-client${NC}"
            echo -e "\nTekan ENTER..."
            read
            continue
        fi

        echo -n -e "${KUNING}[?] Masukkan Host/IP Server MySQL: ${NC}"
        read db_host
        echo -n -e "${KUNING}[?] Masukkan Username MySQL: ${NC}"
        read db_user
        echo -n -e "${KUNING}[?] Masukkan Nama Database yang mau di-dump: ${NC}"
        read db_name
        echo -n -e "${KUNING}[?] Masukkan Nama File Output (cth: backup.sql): ${NC}"
        read out_file

        if [ -z "$db_host" ] || [ -z "$db_user" ] || [ -z "$db_name" ] || [ -z "$out_file" ]; then
            echo -e "${MERAH}[!] Semua data input harus diisi!${NC}"
            read
            continue
        fi

        echo -e "\n${HIJAU}[*] Menjalankan mysqldump... Silakan masukkan password jika diminta.${NC}\n"
        mysqldump -h "$db_host" -u "$db_user" -p "$db_name" > "$out_file"

        if [ $? -eq 0 ]; then
            echo -e "\n${HIJAU}[+] Sukses! Database berhasil di-dump ke file: $out_file${NC}"
        else
            echo -e "\n${MERAH}[!] Gagal melakukan dump database.${NC}"
        fi
        echo -e "\n${KUNING}[*] Selesai. Tekan ENTER...${NC}"
        read
    done
}

menu_vuln() {
    while true; do
        tampilkan_banner
        echo -e "${HIJAU}[ SUB-MENU: VULNERABILITY & BUG SCANNER ]${NC}"
        echo -e "${CYAN}1.${NC} Nmap Vuln Script Scan (Cari Celah Umum)"
        echo -e "${CYAN}2.${NC} Nikto Web Scanner (Cari Bug Server/Web)"
        echo -e "${CYAN}3.${NC} Kembali ke Menu Utama"
        echo ""
        echo -n -e "${KUNING}sdev-vuln > ${NC}"
        read pil_vuln

        if [ "$pil_vuln" -eq 3 ]; then
            break
        fi

        echo -n -e "${KUNING}[?] Masukkan Target (IP atau Domain): ${NC}"
        read v_target

        if [ -z "$v_target" ]; then
            echo -e "${MERAH}[!] Target tidak boleh kosong!${NC}"
            read
            continue
        fi

        case $pil_vuln in
            1)
                echo -e "\n${HIJAU}[*] Menjalankan Nmap NSE Vuln Scripts pada $v_target...${NC}\n"
                nmap --script vuln "$v_target"
                ;;
            2)
                if ! command -v nikto &> /dev/null; then
                    echo -e "${MERAH}[!] Error: Nikto belum terinstall.${NC}"
                    echo -e "${KUNING}[*] Install via Termux: pkg install nikto${NC}"
                    echo -e "${KUNING}[*] Install via Linux : sudo apt install nikto${NC}"
                else
                    echo -e "\n${HIJAU}[*] Menjalankan Nikto Web Scanner pada $v_target...${NC}\n"
                    nikto -h "$v_target"
                fi
                ;;
            *)
                echo -e "${MERAH}[!] Pilihan tidak valid!${NC}"
                ;;
        esac
        echo -e "\n${KUNING}[*] Selesai. Tekan ENTER...${NC}"
        read
    done
}

if ! command -v nmap &> /dev/null; then
    tampilkan_banner
    echo -e "${MERAH}[!] Error: Nmap belum terinstall.${NC}"
    echo -e "${KUNING}[*] Install via Termux: pkg install nmap${NC}"
    echo -e "${KUNING}[*] Install via Linux : sudo apt install nmap${NC}"
    exit 1
fi

while true; do
    tampilkan_banner
    echo -e "${HIJAU}[ MENU UTAMA TOOLKIT ]${NC}"
    echo -e "${CYAN}1.${NC} Nmap Network Scanner"
    echo -e "${CYAN}2.${NC} Sqlmap SQLi Scanner"
    echo -e "${CYAN}3.${NC} SQL Database Dump (mysqldump)"
    echo -e "${CYAN}4.${NC} Vulnerability & Bug Scanner"
    echo -e "${CYAN}5.${NC} Keluar"
    echo ""
    echo -n -e "${KUNING}sdev-main > ${NC}"
    read main_choice

    case $main_choice in
        1) menu_nmap ;;
        2) menu_sqlmap ;;
        3) menu_sqldump ;;
        4) menu_vuln ;;
        5) 
            echo -e "\n${HIJAU}[+] Terimakasih telah menggunakan tool ini. Happy Hacking!${NC}\n"
            exit 0 
            ;;
        *) 
            echo -e "${MERAH}[!] Pilihan tidak valid!${NC}"
            sleep 1
            ;;
    esac
done
