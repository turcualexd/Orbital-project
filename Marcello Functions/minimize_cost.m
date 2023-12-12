function [dv, dep, TOF_1, TOF_2] = minimize_cost(date_dep, date_arr)

mjd2000_dep_min = date2mjd2000(date_dep);

mjd2000_arr_max = date2mjd2000(date_arr);

dtprec = (mjd2000_arr_max - mjd2000_dep_min) / 2;

dtofprec = (2*365-1*365) / 2;

mjd2000_deptilde = mjd2000_dep_min + dtprec;

TOF1tilde = 1 * 365 + dtofprec;

TOF2tilde = 1 * 365 + dtofprec;

dv = 1e10;

dvprec = dv;

toll = 1e-6;

while 1

    dt = dtprec / 2;

    dtof = dtofprec / 2;

    for mjd2000_dep = mjd2000_deptilde - dtprec : dt : mjd2000_deptilde + dtprec

        for TOF1 = TOF1tilde - dtofprec : dtof : TOF1tilde + dtofprec

            for TOF2 = TOF2tilde - dtprec : dt : TOF2tilde + dtprec

                [dv1, ~, V_m] = cost_lambert(mjd2000_dep, mjd2000_dep + TOF1, 4, 3, 0);

                [dv2, ~, V_p] = cost_lambert_2(mjd2000_dep + TOF1, mjd2000_dep + TOF1 + TOF2, 3, 65, 0 );

                dv3 = cost_gravity_assist(mjd2000_dep + TOF1, 3, V_m, V_p);

                dvtot = dv1 + dv2 + dv3;

                dt_tot = mjd2000_dep + TOF1 + TOF2;

                condition = (dvtot<dv).*(dt_tot<mjd2000_arr_max);

                if condition == 1

                    dv = dvtot;

                    dep = mjd2000_dep; 

                    TOF_1 = TOF1;

                    TOF_2 = TOF2;

                end
            end

        end

    end

    dtprec = dt;

    dtofprec = dtof;

    mjd2000_deptilde = dep;

    TOF1tilde = TOF_1;

    TOF2tilde = TOF_2;

    if abs(dv-dvprec) < toll

        break

    end

    dvprec = dv;

end