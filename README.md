# Steady-State-temperature-Distrubution-in-Aluminum-Fin-using-FDM-and-FVM-
**OBJECTIVE**

The objective is to compare the steady-state temperature distribution in an aluminum fin using two numerical methods: Finite Difference Method (FDM) and Finite Volume Method (FVM).

**PROBLEM STATEMENT**

The fin, with an initially uniform temperature of 30°C , as  its  base  maintained  at  a  constant  temperature of 100°C, while the tip is insulated. Fin's geometrical parameters are mentioned in the Heat Conduction png file. By applying the Finite Difference Method (FDM) and Finite Volume Method (FVM) in MATLAB  , the temperature   profile    along   the   length   of   the fin  is   calculated    under  steady - state  conditions.    The    insulated     tip    condition    is    incorporated     into     the    numerical model  to   ensure accurate representation of   the  physical  scenario. The  results  demonstrate  the effectiveness of   the finite difference   method  in   solving  heat  transfer  problems   and   provide insights  into   the thermal behavior of aluminum fins under specified boundary conditions.

**FORMULATION FOR FDM**

Refer to FDM Discretization png file. 

Using mass conservation in the any element
                                                                                                 dm = ρdV 
                                                                                                    = ρAcdx

Law of Energy Conservation
                                                                                            Ėin - Ėout = Ėstored
                                                                                        so, Q̇x-Q̇x+dx=dmCp(dT/dt)................(1)
                                          Here,
                                               Tb = Fin Base temperature
                                               dm= mass of each element
                                               ρ= density of Aluminium fin
                                               Ac= Area of cross-section


From Taylor Series Expansion,
                                                                      f(x+dx) = f(x) + f’(x)dx/1! +f’’(x)(dx)2/2! + f’’’(x)(dx)3/3! +.......
                                                                                     f(x) = Q̇x  and f(x+dx) = Q̇x+dx
neglecting the higher order terms
                                                                                       So, Q̇x+dx = Q̇x+Q̇’xdx/1!...................(2)
                                                                               and Q̇x -( Q̇x+Q̇’x dx/1! )  = ρAcdxCp(dT/dt)
                                                                                     so, - Q̇’x dx/1! = ρAcdxCp(dT/dt)   

For steady-state,dT/dt = 0
                                                                                            So,   Q̇’x = 0....................(3)
From fourier’s law of heat conduction,

                                                                                               Q̇x = KAc(dT/dx)................(4)
                                                                                          so,  dQ̇x/dx=0
                                                                                          so,   d(-KAcdT/dx) = 0
                                                                                          so, d2T/dx2 = 0
                                                                                          






















                                               
