function xout=dhalfbilogis(order,xin,bendparam,lo,hi,newlo,newhi)
	% dhalfbilogis
	% derivative of logit, up to order 2
	%
	% param:
	%	order		the order of the derivative (up to order 2)
	%	xin			the points to be transformed
	%	bendparam		parameter governing how much the logistic curve will bend (10 will give an average curve).
	%	lo			(optional) inf of the domain
	%	hi			(optional) sup of the domain
	%	newlo		(optional) inf of the new domain
	%	newhi		(optional) sup of the new domain
	% 
	% usage:
	%	required: order, xin, bendparam
	%	if lo,hi,newlo,newhi are not supplied then transform is done in place
	%	only supplying lo and hi is kinda useless...
	%	if all are supplied then transforms between the domains (you can mirror the distribution by using something
	%	like (order,xin,bendparam,1,0,0,1))
	%
	% Author: Gene Harvey

	c_3 = bendparam;
	
	switch nargin
		case 3
			lo = min(xin);
			hi = max(xin);
			newlo = lo;
			newhi = hi;
		case 5
			newlo = lo;
			newhi = hi;
		case 7
			% nothing to do here
		otherwise
			error(['Too many or too few arguments. Need either 3, 5, or 7. You entered ' num2str(nargin) '.'])
	end
	
	c_1 = (exp(c_3/2) + 1)/(exp(c_3/2) - 1);
	
	switch order
		case 1
			xout = (c_1.*c_3.*exp((c_3.*(lo - xin))./(2.*hi - 2.*lo)).*(2.*newhi - 2.*newlo))...
					./((exp((c_3.*(lo - xin))./(2.*hi - 2.*lo)) + 1).^2.*(2.*hi - 2.*lo));
		case 2
			xout = (2.*c_1.*c_3.^2.*exp((2.*c_3.*(lo - xin))./(2.*hi - 2.*lo)).*(2.*newhi - 2.*newlo))...
				./((exp((c_3.*(lo - xin))./(2.*hi - 2.*lo)) + 1).^3.*(2.*hi - 2.*lo).^2) ...
				- (c_1.*c_3.^2.*exp((c_3.*(lo - xin))./(2.*hi - 2.*lo)).*(2.*newhi - 2.*newlo))...
				./((exp((c_3.*(lo - xin))./(2.*hi - 2.*lo)) + 1).^2.*(2.*hi - 2.*lo).^2);
	end
	
end