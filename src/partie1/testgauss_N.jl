using Plots
using PyPlot
using LinearAlgebra
"""
 ~gergaud/ENS/Control/ODE/Matlab/test_gauss.m

 Auteurs:  Joseph GERGAUD
 Date:     nov. 2005
 Adresse:  INP-ENSEEIHT-IRIT-UMR CNRS 5055
           2, rue Camichel 31071 Toulouse FRANCE
 Email:    gergaudenseeiht.fr
***************************************************************************

 Int�gration de l'equation differentiel de l'equation de Van der Pol
 ref: Hairer
"""

include("ode_gauss_v2.jl")
include("ode_gauss_v3.jl")
include("phi_vdp.jl")
include("d_phi_vdp.jl")

y0=[2.008619860874843136, 0]
n = length(y0)
t0=0
tf=6.663286859323130189
N0=[120:60:1080; 1200:600:10800] # multiple de 12 pour avoir des nombres entier si on divise par 4 ou 3
N=N0
#
# Gauss Newton

#clear T Y err1 err2

s = 2
N = N0/(2*s)
#N = 10
options = zeros(3)
err1 = zeros(length(N0))
err2 = zeros(length(N0))
Nphie = zeros(length(N0))
# options(2) = nbre max iteration point fixe
options[2] = 15
# epsilon pour le test du point fixe
# Il faut 1.e-12 car pour les valeurs de N grandes on atteint avec RK4 1.e-12
# comme erreur absolue
options[3] = 1e-12
Ifail = []
for i=1:length(N)
    options[1] = N[i] 
    T,Y,nphie,ndphie,ifail = ode_gauss_v3(phi_vdp,d_phi_vdp,[t0 tf],y0,options)
    if Ifail != []
        global Ifail = [Ifail length(findall(ifail==-1))] 
    else
        global Ifail = length(findall(ifail==-1)) 
    end
    n = length(T)
    err1[i] = abs(y0[1]-Y[n,1])
    err2[i] = abs(y0[2]-Y[n,2])
    Nphie[i] = nphie + n * ndphie
end
# Inutile de trie car deja en ordre
#PyPlot.figure(1) # pour verifier l"ordre
# ---------------------
pyplot()
plt = Plots.plot(layout=(2,2))
#PyPlot.subplot(1,2,1)
#hold on
Plots.plot!(log10.(N0),log10.(err1),subplot=1)  
#PyPlot.subplot(1,2,2)
#hold on
Plots.plot!(log10.(N0),log10.(err2),subplot=2)
#figure(2) 
# vraie courbe
# ------------
#plt = Plots.plot(layout=(1,2))
#subplot(1,2,1)
Plots.plot!(log10.(Nphie),log10.(err1),color="red",subplot=3)
i=round(length(N)/2)
#text(log10(Nphie[i] ) ,log10(err1[i] ) ,"\color{red}Gauss")
#xlabel("log_{10}(fe)")
#ylabel("log_{10}(erreur pour y_1)")     
#v=axis
#axis([v(1) v(2) v(3)-4 v(4)])
#subplot(1,2,2)
Plots.plot!(log10.(Nphie),log10.(err2),color="red",subplot=4)
i=round(length(N)/2)
#text(log10(Nphie[i] ) ,log10(err2[i] ) ,"\color{red}Gauss")
#xlabel("log_{10}(nphi)")
#ylabel("log_{10}(erreur pour y_2)") 
#axis([v(1) v(2) v(3)-4 v(4)])
#legend("Euler", "Runge","Heun","RK4_1","RK4_2","gauss v2 feps=1.e-12","Location","SouthWest")
#=figure(3) 


T,Y,nphie,ndphie,ifail,KK = ode_gauss_v3(phi_vdp,d_phi_vdp,[t0 tf],y0,options)
=#
display(plt)
