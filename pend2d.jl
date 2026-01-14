using DifferentialEquations
using Plots

function pendulo!(du, u, p, t)
    theta, omega = u
    g, L = p
    du[1] = omega
    du[2] = -(g/L) * sin(theta)
end

# 2. Configuração dos Parâmetros
g = 9.81          # Gravidade (m/s^2)
L = 1.0           # Comprimento do fio (m)
m = 1.0           # Massa (kg) - *nota: não afeta a cinemática do pêndulo simples*
t_final = 10.0    # Duração do vídeo (segundos)
theta0 = π/4      # Ângulo inicial (45 graus)
omega0 = 0.0      # Velocidade angular inicial

p = (g, L)
u0 = [theta0, omega0]
tspan = (0.0, t_final)

# 3. Resolver a EDO
prob = ODEProblem(pendulo!, u0, tspan, p)
sol = solve(prob, Tsit5(), saveat=0.05) # saveat 0.05 garante ~20fps suave

# 4. Criar a Animação
anim = @animate for (i, t) in enumerate(sol.t)
    theta = sol[1, i]
    
    # Converter coordenadas polares para cartesianas
    # O pivô é (0,0), o pêndulo desce em y negativo
    x = L * sin(theta)
    y = -L * cos(theta)
    
    # Configuração do Plot
    plot([0, x], [0, y], 
        linewidth=3, 
        color=:black, 
        label="", 
        xlims=(-L-0.5, L+0.5), 
        ylims=(-L-0.5, 0.5), 
        aspect_ratio=:equal,
        title = "Simulação Pêndulo Simples: t=$(round(t, digits=1))s",
        grid = false,
        axis = nothing,
        border = :none
    )
    
    # Desenhar o Pivô (ponto fixo)
    scatter!([0], [0], markersize=8, color=:black, label="")
    
    # Desenhar a Bolinha (massa)
    scatter!([x], [y], markersize=15, color=:red, markerstrokewidth=0, label="")
end

# 5. Salvar o Vídeo
println("Gerando vídeo...")
mp4(anim, "movimento_pendulo.mp4", fps = 30)
println("Vídeo salvo como 'movimento_pendulo.mp4'")