from faker import Faker

# Cria uma instância do Faker
faker = Faker()

# Gera 10 nomes de empresas aleatórios
for _ in range(24):
    print(faker.name_male().upper())
