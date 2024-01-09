function [deltav_tot, VI, VF] = cost_lambert(departure, arrival, ibody1, ibody2, orbitType )

TOF = (arrival - departure)*24*3600;

[kep1,ksun1] = uplanet(departure, ibody1);

[RI, V1] = kep2car(kep1(1),kep1(2),kep1(3),kep1(4),kep1(5),kep1(6), ksun1);

[kep2,ksun2] = uplanet(arrival, ibody2);

[RF, ~] = kep2car(kep2(1),kep2(2),kep2(3),kep2(4),kep2(5),kep2(6), ksun2);

[~,~,~,~,VI,VF,~,~] = lambertMR(RI,RF,TOF,ksun1,orbitType,0);

deltav1 = norm(VI'-V1);


VI = VI';

VF = VF';

deltav_tot = deltav1;

end
