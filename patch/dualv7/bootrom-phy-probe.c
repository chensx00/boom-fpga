#include <stdint.h>
#include "common.h"
#include "kprintf.h"

#define ETH_BASE      0x60020000U
#define ETH_CAP       ((volatile unsigned *)(ETH_BASE + 0x02C))
#define ETH_MAC_STAT  ((volatile unsigned *)(ETH_BASE + 0x000))
#define ETH_NIC_STAT  ((volatile unsigned *)(ETH_BASE + 0x004))
#define ETH_INT_STAT  ((volatile unsigned *)(ETH_BASE + 0x00C))
#define ETH_NIC_CTRL  ((volatile unsigned *)(ETH_BASE + 0x020))
#define ETH_MDIO_TX   ((volatile unsigned *)(ETH_BASE + 0x024))
#define ETH_MDIO_RX   ((volatile unsigned *)(ETH_BASE + 0x028))

#define INT_MDIO      (1u << 18)
#define CTRL_MDIO_RST (1u << 2)

#define BMCR   0
#define BMSR   1
#define PHYID1 2
#define PHYID2 3
#define ANAR   4
#define ANLPAR 5

extern unsigned char _fbss[];
extern unsigned char _ebss[];

static void usleep(unsigned us)
{
    uintptr_t c0, c1;
    asm volatile ("csrr %0, 0xB00" : "=r" (c0));
    for (;;) {
        asm volatile ("csrr %0, 0xB00" : "=r" (c1));
        if (c1 - c0 >= (uintptr_t)us * 100) break;
    }
}

static int mdio_read(unsigned phy, unsigned reg, unsigned *val)
{
    unsigned tx = (0x6u << 28) | ((phy & 0x1f) << 23) | ((reg & 0x1f) << 18);
    unsigned timeout;
    *ETH_MDIO_TX = tx;
    for (timeout = 0; timeout < 100000; timeout++) {
        if (*ETH_INT_STAT & INT_MDIO) break;
        usleep(10);
    }
    if (timeout >= 100000) return -1;
    unsigned rx = *ETH_MDIO_RX;
    if ((rx & 0xfffc0000u) != (tx & 0xfffc0000u)) return -2;
    *val = rx & 0xffff;
    return 0;
}

static void mdio_reset(void)
{
    unsigned t, val;
    kprintf("mdio_reset: asserting\n");
    *ETH_NIC_CTRL |= CTRL_MDIO_RST;
    for (t = 0; t < 1000; t++) {
        if (mdio_read(0, PHYID1, &val) != 0 || val == 0xffff) break;
        usleep(10000);
    }
    usleep(10000);
    kprintf("mdio_reset: deasserting\n");
    *ETH_NIC_CTRL &= ~CTRL_MDIO_RST;
    for (t = 0; t < 1000; t++) {
        mdio_read(0, PHYID1, &val);
        if (val > 0 && val < 0xffff) break;
        usleep(10000);
    }
    usleep(10000);
    kprintf("mdio_reset: done\n");
}

void main(void)
{
    uint64_t *bss = (uint64_t *)_fbss;
    while (bss < (uint64_t *)_ebss) *bss++ = 0;
    kprintf("PHYPROBE 041x\n");
    unsigned cap  = *ETH_CAP;
    unsigned mac  = *ETH_MAC_STAT;
    unsigned nic  = *ETH_NIC_STAT;
    unsigned ints = *ETH_INT_STAT;
    unsigned ctrl = *ETH_NIC_CTRL;
    kprintf("ETH cap=%08x mac=%08x nic=%08x int=%08x ctl=%08x\n",
            cap, mac, nic, ints, ctrl);
    if (!(cap & 0x100)) {
        kprintf("FATAL: MDIO not enabled\n");
        for (;;) usleep(1000000);
    }
    mdio_reset();
    kprintf("ETH cap=%08x mac=%08x nic=%08x int=%08x ctl=%08x\n",
            *ETH_CAP, *ETH_MAC_STAT, *ETH_NIC_STAT,
            *ETH_INT_STAT, *ETH_NIC_CTRL);
    unsigned p;
    for (p = 0; p < 32; p++) {
        unsigned id1, id2;
        int r1 = mdio_read(p, PHYID1, &id1);
        if (r1 != 0) {
            kprintf("SCAN phy=%02u timeout/eio r1=%d\n", p, r1);
            continue;
        }
        int r2 = mdio_read(p, PHYID2, &id2);
        if (id1 == 0xffff && id2 == 0xffff) {
            kprintf("SCAN phy=%02u ffff\n", p);
        } else {
            kprintf("SCAN phy=%02u id1=%04x id2=%04x\n", p, id1, id2);
        }
    }
    unsigned phy = 32;
    for (p = 0; p < 32; p++) {
        unsigned id1, id2;
        if (mdio_read(p, PHYID1, &id1) == 0
            && mdio_read(p, PHYID2, &id2) == 0
            && id1 != 0xffff && id2 != 0xffff) {
            phy = p; break;
        }
    }
    if (phy >= 32) {
        kprintf("ALL_SCAN_FAIL\n");
        for (;;) usleep(1000000);
    }
    kprintf("TARGET phy=%02u\n", phy);
    unsigned loop = 0;
    for (;;) {
        unsigned bmcr, bmsr1, bmsr2, anar, anlpar;
        unsigned r_mac = *ETH_MAC_STAT;
        unsigned r_nic = *ETH_NIC_STAT;
        mdio_read(phy, BMCR,   &bmcr);
        mdio_read(phy, BMSR,   &bmsr1);
        usleep(1000);
        mdio_read(phy, BMSR,   &bmsr2);
        mdio_read(phy, ANAR,   &anar);
        mdio_read(phy, ANLPAR, &anlpar);
        kprintf("POLL t=%u phy=%02u bmcr=%04x bmsr1=%04x bmsr2=%04x anar=%04x anlpar=%04x mac=%08x nic=%08x\n",
                loop, phy, bmcr, bmsr1, bmsr2, anar, anlpar, r_mac, r_nic);
        loop++;
        usleep(500000);
    }
}
