# Preliminary Mission Design Tool (PMDT)

This repository contains the code for the **Preliminary Mission Design Tool (PMDT)**, used in the paper titled ["Design and guidance of a multi-active debris removal mission"](https://link.springer.com/article/10.1007/s42064-023-0159-3) by **Minduli C. Wijayatunga**, **Roberto Armellin**, **Harry Holt**, **Laura Pirovano**, and **Aleksander A. Lidtke**.

The PMDT generates multi-target, fuel- and time-optimal tours for active debris removal (ADR) missions using low-thrust propulsion. It accounts for various mission factors, such as J2 perturbations, drag, eclipses, and duty cycles. The tool can rapidly compute reference trajectories, providing solutions for 5-year low-thrust tours within seconds.

The tool was developed for a multi-debris mission concept studied in collaboration with **Astroscale** and **Rocket Lab**, where two spacecraft work together to remove multiple debris in a single mission. A visual representation of this mission concept is shown below:

<p align="center">
  <img src="https://github.com/user-attachments/assets/861e459c-6aae-47e0-b319-1e0dfa2f5832" width="600" />
  <br>
  <i>Mission Concept for Multi-Debris Removal</i>
</p>

Additionally, the code includes a **Matlab app** that allows users to interact with the PMDT directly. This app can be generated by running the `PMDTApp.m` file.

<p align="center">
  <img src="https://github.com/user-attachments/assets/6c9d1a82-9df5-4211-9796-2fa8dbfbcd77" width="800" />
  <br>
  <i> PMDT Matlab App Interface </i>
</p>
If you prefer to run the code without using the app, you can use the `main.m` file, where you can directly change the parameters for the mission.

## Prerequisites

SPICE toolkit for Matlab (can be downloaded at https://naif.jpl.nasa.gov/naif/toolkit_MATLAB.html) 


## How PMDT Works

The PMDT utilizes **J2 perturbations** to facilitate changes in the **Right Ascension of Ascending Node (RAAN)** without any fuel cost. This is achieved by having the spacecraft wait in **drift orbits**, leveraging the J2 effect to slowly evolve the RAAN without using propellant. Changes in **Semi-Major Axis (SMA)** and **Inclination** are handled using the **extended Edelbaum method**, which is discussed in detail in the paper. This method allows the spacecraft to efficiently adjust these orbital elements in a fuel-optimal manner, balancing time and fuel consumption for the mission. Our follow-up work, titled **["Convex-Optimization-Based Model Predictive Control for Space Debris Removal Mission Guidance"](https://arc.aiaa.org/doi/abs/10.2514/1.G008089?journalCode=jgcd)**, applies **convex-MPC** to track the PMDT-generated trajectories. This paper demonstrates how the PMDT method's high accuracy allows the use of single-iteration convex optimization for real-time guidance of these ADR missions. 


## Link to the paper
For more details, read the full paper: [Design and guidance of a multi-active debris removal mission](https://link.springer.com/article/10.1007/s42064-023-0159-3)

## Contact
If you encounter any bugs or issues, feel free to reach out via email: [minduli1999@gmail.com](mailto:minduli1999@gmail.com).
