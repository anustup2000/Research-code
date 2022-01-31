import meep as mp
import argparse
import numpy as np
import matplotlib.pyplot as plt

def main(args):
    n= 1.44 # refractive index of ghe microdisk (silica)
    n_clad= 1.85 # refractive index of hBN
    w= 15        # radius of the microdisk (in microns)
    Angle=53
    wedgeAngle= Angle*np.pi/180
    taperAngle= (90-Angle)*np.pi/180 # angle of the disk edge
    #w_diff= 2.25 # difference in diameter between upper and lower radius (in microns)
    factor=np.tan(wedgeAngle)
    factor2=np.sin(wedgeAngle)
    h= 1.4 # width of the microdisk (in microns)
    c= 0.015 # hBN thickness (vary between 0 to 0.4)
    pad= 5 # padding between the waveguide and PML edge
    dpml= 5 # PML thickness
    sr= c + w + pad + dpml # radial size of the computational cell
    sz= c + h + 2*pad + 2*dpml # height of the computationgl cell
    dimensions= mp.CYLINDRICAL
    cell= mp.Vector3(sr,0,sz) #defining the computational cell in terms of cylindrical coordinates
    m=args.m

   #geometry=[mp.Cone(center= mp.Vector3(0,0,0),height= h,radius= w-h*np.sin(taperAngle),radius2= w+h*np.sin(taperAngle),axis= mp.Vector3(0,0,1),material= mp.Medium(index= n))]
    #geometry=[mp.Cone(center=mp.Vector3(0,0,0),height=h+2*c,radius=(w+c)-(h+2*c)*np.sin(taperAngle),radius2=(w+c)+(h+2*c)*np.sin(taperAngle),axis=mp.Vector3(0,0,1),material=mp.Medium(index=n_clad)),mp.Cone(center=mp.Vector3(0,0,0),height=h,radius=w-h*np.sin(taperAngle),radius2=w+h*np.sin(taperAngle),axis=mp.Vector3(0,0,1),material=mp.Medium(index=n))]
    #geometry=[mp.Cone(center=mp.Vector3(0,0,0),height= h+2*c,radius=w-((h+2*c)/factor),radius2=w,axis=mp.Vector3(0,0,1),material= mp.Medium(index= n_clad)),mp.Cone(center=mp.Vector3(0,0,0),height= h,radius=w-(h+4*c)/factor,radius2= w-(4*c/factor),axis=mp.Vector3(0,0,1),material=mp.Medium(index= n))]
    hl= h+2*c
    rl1=w-hl/factor
    #rl1= w+c/factor3-(h+c)/factor-c/factor2
    rl2= w
    hs= h
    rs1= w-(h+c)/factor-c/factor2
    rs2= w-c/factor-c/factor2
    
    
    geometry=[mp.Cone(center= mp.Vector3(0,0,0),height=hl,radius=rl1,radius2=rl2,axis=mp.Vector3(0,0,1),material=mp.Medium(index=n_clad)),mp.Cone(center=mp.Vector3(0,0,0),height=hs,radius=rs1,radius2=rs2,axis= mp.Vector3(0,0,1),material=mp.Medium(index=n))]
    pml_layers =[mp.PML(dpml)]
    resolution = 15

    fcen= args.fcen
    df= args.df
    # putting a single point source at an arbitrary place in an arbitrary directop, looking for Ez polarised modes (TM)
    #source_position_r= w-0.25*(3*h+11*c)/(factor)
    source_position_r= w-0.25*(3*h+4*c)/factor-0.5*c/factor2
    source_position_theta= 0
    source_position_z= h/4
    sources= [mp.Source(src=mp.GaussianSource(fcen,fwidth=df),component=mp.Ez,center=mp.Vector3(source_position_r,source_position_theta,source_position_z))]

    sim= mp.Simulation(cell_size=cell,geometry=geometry,boundary_layers=pml_layers,resolution=resolution,sources=sources,dimensions=dimensions,m=m)

    sim.run(mp.after_sources(mp.Harminv(mp.Ez,mp.Vector3(source_position_r,source_position_theta,source_position_z),fcen,df)),until_after_sources=200)
    # output fieldg for one period at the end. (if we output at a single time, we might accidentally catch the E-z field when its nearly zero, and get a distorted field view). The data will be outputted in a rby t format. Output would be from -sr to sr (instead of 0 to sr)
    sim.run(mp.in_volume(mp.Volume(center=mp.Vector3(),size=mp.Vector3(2*sr,0,sz)),mp.at_beginning(mp.output_epsilon),mp.to_appended("e",mp.at_every(1/fcen,mp.output_efield))),until=1/fcen)
    # plot dielectric and field data
    #sim.run(mp.after_sources(mp.Harminv(mp.Er,mp.Vector3(w-0.01,0,h/4),fcen,df)),until_after_sources=200)
    #sim.run(mp.in_volume(mp.Volume(center=mp.Vector3(),size=mp.Vector3(2*sr,0,sz)),mp.at_beginning(mp.output_epsilon),mp.to_appended("er",mp.at_every(1/fcen/20,mp.output_efield_r))),until=1/fcen)
    #sim.run(mp.after_sources(mp.Harminv(mp.Ep,mp.Vector3(w-0.01,0,h/4),fcen,df)),until_after_sources=200)
    #sim.run(mp.in_volume(mp.Volume(center=mp.Vector3(),size=mp.Vector3(2*sr,0,sz)),mp.at_beginning(mp.output_epsilon),mp.to_appended("ep",mp.at_every(1/fcen/20,mp.output_efield_p))),until=1/fcen)

    eps_data= sim.get_array(center=mp.Vector3(),size=cell,component=mp.Dielectric)
    #plt.figure()
    #plt.imshow(eps_data.transpose(),interpolation='spline36',cmap='binary')
    #plt.axis('off')
    #plt.show()
    #er_data = sim.get_array(center=mp.Vector3(),size=cell,component=mp.Er)
    #ep_data = sim.get_array(center=mp.Vector3(),size=cell,component=mp.Ep)
    #ez_data = sim.get_array(center=mp.Vector3(),size=cell,component=mp.Ez)
    #plt.figure()
    #plt.imshow(eps_data.transpose(),interpolation='spline36',cmap='binary')
    #plt.imshow(np.absolute(ez_data.transpose()),interpolation='spline36',cmap='RdBu',alpha=0.9)
    #plt.axis('off')
    #plt.show()

if __name__ == '__main__':
    parser=argparse.ArgumentParser()
    parser.add_argument('-fcen',type=float,default=0.6123465,help='pulse center frequency')
    parser.add_argument('-df',type=float,default=0.3,help='pulse frequency width')
    parser.add_argument('-m',type=int,default= 5,help='order of mode')


    args=parser.parse_args()
    main(args)
