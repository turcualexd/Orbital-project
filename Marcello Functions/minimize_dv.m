function [dv, dep, TOF_1, TOF_2] = minimize_dv(date_dep, date_arr)

mjd2000_dep_min = date2mjd2000(date_dep);

mjd2000_arr_max = date2mjd2000(date_arr);

dtprec = (mjd2000_arr_max + mjd2000_dep_min) / 2;

%TOF_max = dtprec * 2;

mjd2000_deptilde = mjd2000_dep_min + dtprec;

TOF1tilde = dtprec;

TOF2tilde = dtprec;

dv = 1e10;

toll = 1e-4;

while 1

    dt = dtprec/2;

    for mjd2000_dep = mjd2000_deptilde - dtprec : dt : mjd2000_deptilde + dtprec

        for TOF1 = TOF1tilde - dtprec : dt : TOF1tilde + dtprec

            for TOF2 = TOF2tilde - dtprec : dt : TOF2tilde + dtprec

                [dv1, ~, V_m] = cost_lambert(mjd2000_dep, mjd2000_dep + TOF1, 4, 3, 0);

                [dv2, ~, V_p] = cost_lambert_2(mjd2000_dep + TOF1, mjd2000_dep + TOF1 + TOF2, 3, 65, 0 );

                dv3 = cost_gravity_assist(mjd2000_dep + TOF1, 3, V_m, V_p);

                dvtot = dv1 + dv2 + dv3;

                if (dvtot < dv)&&(mjd2000_dep + TOF1 + TOF2) < mjd2000_arr_max
                    %&&mjd2000_dep>mjd2000_dep_min

                    dv = dvtot;

                    TOF_1 = TOF1;

                    TOF_2 = TOF2;

                    dep = mjd2000_dep;

                end


            end

        end

    end

    dtprec = dt;

    mjd2000_deptilde = dep;

    TOF1tilde = TOF_1;

    TOF2tilde = TOF_2;

    dvprec = dv;

    if abs(dv - dvprec) < toll

        break

    end

end