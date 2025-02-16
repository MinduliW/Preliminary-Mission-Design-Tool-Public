function hill = kep2hill(kep, mu)

if kep(2) == 0 
    kep(2) = 1e-10;
end

p = kep(1)*(1.0 - kep(2)*kep(2));
f = kep(6);
hill(5) = sqrt(mu*p); % angular momentum 
hill(1) = p/(1.0 + kep(2)*cos(f)); % radius 
hill(2) = f + kep(5); %argument of latitude 
hill(3) = kep(4); %RAAN
hill(4) = (hill(5)/p)*kep(2)*sin(f); %r dot
hill(6) = hill(5)*cos(kep(3)); % H cos(i) polar component of angular momentum 

end





