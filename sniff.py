# use scapy to sniff incomming packets

from scapy.all import *


def http_post(dst_addr, data):
    url = 'http://' + dst_addr
    payload = data

def pkt_callback(pkt):
    if Raw in pkt:
        #result = dict()
        #result.update(src_addr = pkt[IP].src)
        #result.update(dst_addr = pkt[IP].dst)
        #result.update(timestamp = pkt[TCP].options[2][1])
        #result.update(data = pkt.load)
    
        return pkt.load

sniff(iface="enp3s0", prn=pkt_callback, filter="tcp port 8000")
