Red [	Title:   "Integral2"	Author:  "Francois Jouen"	File: 	 %integral2.red	Needs:	 'View]; required last Red Master#include %../../libs/redcv.red ; for red functionsthresh: 127boxW: 5boxH: 5margins: 5x5msize: 610x340intSize: 32img1: rcvCreateImage msize				; srcgray: rcvCreateImage img1/size			; gray scalesum: rcvCreateImage img1/size			; dst 1sqsum: rcvCreateImage img1/size			; dst 2plot: copy []loadImage: does [	canvas1/image: black	canvas2/image: black	canvas2/draw: []	clear sb/text	tmp: request-file	if not none? tmp [		img1: rcvLoadImage  tmp		gray: rcvCreateImage img1/size ; just for visualization		rcv2Gray/average img1 gray		sum: rcvCreateMat 'integer! intSize img1/size		sqsum: rcvCreateMat 'integer! intSize img1/size		mat1: rcvCreateMat 'integer! intSize img1/size		rcvImage2Mat img1 mat1 				; Converts  image to 1 Channel matrix [0..255]		rcvIntegral mat1 sum sqsum img1/size ; on travaille sur la matrice 		canvas1/image: img1		canvas2/image: gray	]]ProcessImage: does [	canvas2/image: black	plot: copy [line-width 1 pen green]	canvas2/draw: []	if error? try [boxW: to integer! wt/data] [boxW: 5]	if error? try [boxH: to integer! ht/data] [boxH: 5]	w: img1/size/x - 1	h: img1/size/y - 1	y: boxH 	x: boxW 	while [y < h] [		s: copy "Processing line " 		append s y		sb/text: s		show win		while [x < w] [			scal0: rcvGetInt2D sum img1/size as-pair x y			scal1: rcvGetInt2D sum img1/size as-pair (x - boxW) (y - boxH)  			scal2: rcvGetInt2D sum img1/size as-pair x (y - boxH) 			scal3: rcvGetInt2D sum img1/size as-pair (x - boxW) y			val: (scal0 + scal1 - scal2 - scal3)			val: val / (boxW * boxH)          	topLeft: as-pair (x - boxW) (y - boxH)       	 	bottomRight: as-pair (x) (y)			if val <= thresh [				append plot compose [box (topLeft) (bottomRight)]			]		x: x + 1		]	x: boxW	y: y + 1	]		s: copy "Be patient! Drawing result " 	sb/text: s	show win		;canvas2/image: gray	canvas2/draw: plot		s: copy "Done " 	sb/text: s	show win]; ***************** Test Program ****************************view win: layout [		title "Integral Image"		origin margins space margins		button 100 "Load Image" 	[loadImage]		text "Threshold" sl: slider 200 	[slt/data: to integer! face/data * 255 thresh: to integer! slt/data] 		slt: field 50 "127"		text "Box [w h]"		wt: field 40 "5" [if error? try [boxW: to integer! wt/data] [boxW: 5]]		ht: field 40 "5" [if error? try [boxH: to integer! ht/data] [boxH: 5]]		button 100 "Process" 		[ProcessImage]		button 100 "Quit" 			[rcvReleaseImage img1  Quit]		return				text 640 "Source" center  text  640 "Integral" center 		return		canvas1: base msize img1		canvas2: base msize gray		return		sb: field 512		do [sl/data: 0.5]		]