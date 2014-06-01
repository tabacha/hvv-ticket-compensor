#!/bin/bash
MAILSERVER=mail.example.com
PRINTER=oj6500a
ssh -i $HOME/.ssh/hvv-tickets root@${MAILSERVER} /usr/local/bin/hvv-extrakt.sh
scp -p -q -i $HOME/.ssh/hvv-tickets root@{MAILSERVER}:/home/tickets/*.pdf /home/tickets

for INFILE in /home/tickets/*.pdf ; do
if [ ! -f ${INFILE}.done ]; then 
    #echo $INFILE
    DIR=/tmp/ti-$(date +%s)

    rm -f /tmp/ti/*.png
    mkdir -p $DIR
    cd $DIR
    /usr/bin/convert -density 300  -quality 100 ${INFILE} ti.png
    let i=0
    let o=0
    let e=2
    let s=0
    while [ -f ti-$i.png ]; do
#    echo $i
        /usr/bin/convert ti-${i}.png -crop 2480x1200+0+2305 +repage to-${i}.png
        if [ $i -eq $e ] ; then
            /usr/bin/montage to-[${s}-${e}].png -tile 1x3 -geometry +0+0 out.png
            lp -d ${PRINTER} out.png
            let s=$s+3
            let e=$e+3
            rm out.png
        fi
        let i++
    done
    if [ $i -ne $s ] ; then
#    echo i $i
        /usr/bin/montage to-[${s}-${e}].png -tile 1x3 -geometry +0+0 out2.png
        convert -density 300  out2.png -bodercolor white -border 0x100  -quality 100 out2.pdf

        lp -d {PRINTER} out2.pdf
    fi
    rm -rf $DIR
    touch  ${INFILE}.done
fi
done