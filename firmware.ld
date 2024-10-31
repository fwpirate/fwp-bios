OUTPUT_FORMAT("binary")

SECTIONS
{
    . = 0x000FFFF0;     /* Reset vector */
    .reset_vector : {
        *(.reset_vector)
    }

    . = 0x000F0000;     /* BIOS code start */
    .bios : {
        *(.bios)
    }
}
