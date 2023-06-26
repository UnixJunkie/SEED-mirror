import numpy as np
import matplotlib.pyplot as plt


def softcore_potential(r, lamb, epsilon, sigma, alpha, n=1):
    """
    Parameters
    ----------
    r : np.array
        distance between the particles
    epsilon : float
        depth of the potential well
    sigma : float
        distance at which the potential is zero
    n : float
        exponent of the potential

    Returns
    -------
    V_softcore : float
        softcore potential
    """
    prefactor = 4*epsilon*lamb**n
    denom = alpha*(1-lamb)**2 + (r/sigma)**6 

    V_softcore = prefactor * (1/denom**2 - 1/denom)
    return V_softcore

def softcore_shift_potential(r, lamb, epsilon, sigma, alpha, n=1):
    r_shift = r - sigma*(2**(1/6) - (-lamb**2 + 2*lamb +1)**(1/6))
    V_softcore = softcore_potential(r_shift, lamb, epsilon, sigma, alpha, n)

    # reinforce the boundary conditions
    very_small = 1e-10
    boundary_value = softcore_potential(very_small, lamb, epsilon, sigma, alpha, n)
    V_softcore[r_shift < 0] = boundary_value

    return V_softcore

# Parameters
lambs = np.linspace(0, 1, 11)
epsilon = 1
alpha = 1.0
sigma = 3.5 # angstrom
epsilon = 0.066 # kcal/mol
exp_n = 1

r = np.linspace(0.01, 10, 1000)
V = np.zeros((len(lambs), len(r)))
V_shifted = np.zeros((len(lambs), len(r)))

for i, lamb in enumerate(lambs):
    V[i] = softcore_potential(r, lamb, epsilon, sigma, alpha, n=exp_n)
    V_shifted[i] = softcore_shift_potential(r, lamb, epsilon, sigma, alpha, n=exp_n)

# Plot:
fig, ax = plt.subplots()
for i, lamb in enumerate(lambs):
    ax.plot(r, V[i], label=f'$\lambda$ = {lamb:.1f}')
ax.set_xlabel('r [Å]')
ax.set_ylabel('V [kcal/mol]')
ax.set_ylim(-epsilon, 2*epsilon)
ax.set_xlim(-sigma*0.5, sigma*2.5)
ax.legend(loc = 'upper right')
ax.set_title(f'Softcore potential, alpha={alpha}, sigma={sigma}, epsilon={epsilon}, n={exp_n}')
plt.show()

# Plot:
fig, ax = plt.subplots()
for i, lamb in enumerate(lambs):
    ax.plot(r, V_shifted[i], label=f'$\lambda$ = {lamb:.1f}')
ax.set_xlabel('r [Å]')
ax.set_ylabel('V [kcal/mol]')
ax.set_ylim(-epsilon, 2*epsilon)
ax.set_xlim(-sigma*0.5, sigma*2.5)
ax.legend(loc = 'upper right')
ax.set_title(f'Softcore shifted potential, alpha={alpha}, sigma={sigma}, epsilon={epsilon}, n={exp_n}')
plt.show()
