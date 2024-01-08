function [dv, rp] = cost_gravity_assist(time, id, V_m, V_p)

mu_E = astroConstants(13);

RE = astroConstants(23);

[kep1,ksun1] = uplanet(time, id);

[~, VP] = kep2car(kep1(1),kep1(2),kep1(3),kep1(4),kep1(5),kep1(6), ksun1);

v_m = V_m - VP;

v_p = V_p - VP;

delta = acos(dot(v_m, v_p) / (norm(v_m) * norm(v_p)));

rp = compute_delta(mu_E, norm(v_m), norm(v_p), delta, RE);

v_mn = norm(v_m);

v_pn = norm(v_p);

vp1 = sqrt(v_mn^2 + 2*mu_E/rp);

vp2 = sqrt(v_pn^2 + 2*mu_E/rp);

dv = norm(vp1 - vp2);

    if rp < (astroConstants(23) + 500)
        
        dv = 10;

    end

end