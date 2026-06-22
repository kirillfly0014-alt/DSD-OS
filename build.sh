cat > build.sh << 'EOF'
#!/bin/bash
echo "=== Building DSD v1.0 ==="
rm -f dsd_floppy.img dsd_boot.bin stage2.bin
echo "Creating floppy image..."
dd if=/dev/zero of=dsd_floppy.img bs=512 count=2880
echo "Assembling stage1 (bootloader)..."
nasm -f bin dsd_boot.asm -o dsd_boot.bin
dd if=dsd_boot.bin of=dsd_floppy.img bs=512 count=1 conv=notrunc
echo "Assembling stage2 (kernel)..."
nasm -f bin stage2.asm -o stage2.bin
dd if=stage2.bin of=dsd_floppy.img bs=512 seek=1 conv=notrunc
echo "Build complete! -> dsd_floppy.img"
echo "Run with: qemu-system-i386 -fda dsd_floppy.img -boot a -nographic"
EOF
chmod +x build.sh
