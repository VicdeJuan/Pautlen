;D:	main
;D:	{
;D:	int
;D:	x
;D:	,
;D:	resultado
;D:	;
;D:	function
;D:	int
;D:	fibonacci
;D:	(
;D:	int
;D:	num1
;D:	)
;D:	{
;D:	int
;D:	res1
;D:	,
;D:	res2
;D:	;
;D:	if
;D:	(
;D:	(
;D:	num1
;D:	==
;D:	0
;D:	)
;D:	)
;D:	{
;D:	return
;D:	0
;D:	;
;D:	}
;D:	if
;D:	(
;D:	(
;D:	num1
;D:	==
;D:	1
;D:	)
;D:	)
;D:	{
;D:	return
;D:	1
;D:	;
;D:	}
;D:	res1
;D:	=
;D:	fibonacci
;D:	(
;D:	num1
;D:	-
;D:	1
;D:	)
;D:	;
;D:	res2
;D:	=
;D:	fibonacci
;D:	(
;D:	num1
;D:	-
;D:	2
;D:	)
;D:	;
;D:	return
;D:	res1
;D:	+
;D:	res2
;D:	;
;D:	}
;D:	scanf
;D:	x
;D:	;
;D:	x
;D:	=
;D:	fibonacci
;D:	(
;D:	x
;D:	)
;D:	;
;D:	printf
;D:	x
;D:	;
;D:	}
