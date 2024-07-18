import pandas as pd

def concat_devolucao():
    try:
        devolucao_2022 = pd.read_excel('dados/devolucao/view_bi_vendedor_devolucao_2022.xlsx')
        devolucao_2023 = pd.read_excel('dados/devolucao/view_bi_vendedor_devolucao_2023.xlsx')
        devolucao_2024 = pd.read_excel('dados/devolucao/view_bi_vendedor_devolucao_2024.xlsx')
    except InterruptedError as e:
        print(f'Erro na importação dos arquivos de devolução: {e}')


    devolucao = pd.concat([devolucao_2022,devolucao_2023,devolucao_2024], ignore_index=True) 
   
    try:  
        devolucao.to_excel('dados/view_bi_vendedor_devolucao.xlsx', index=False)
    except InterruptedError as e:
        print(f'Erro na gravação o arquivo de devolução: {e}')


def concat_venda():
    try:
        venda_2022_1 = pd.read_excel('dados/venda/view_bi_vendedor_venda_2022_1.xlsx')
        venda_2022_2 = pd.read_excel('dados/venda/view_bi_vendedor_venda_2022_2.xlsx')
        venda_2023_1 = pd.read_excel('dados/venda/view_bi_vendedor_venda_2023_1.xlsx')
        venda_2023_2 = pd.read_excel('dados/venda/view_bi_vendedor_venda_2023_2.xlsx')
        venda_2024_1 = pd.read_excel('dados/venda/view_bi_vendedor_venda_2024_1.xlsx')
        
    except InterruptedError as e:
        print(f'Erro na importação dos arquivos de venda: {e}')


    venda = pd.concat(
                        [   venda_2022_1,
                            venda_2022_2,
                            venda_2023_1,
                            venda_2023_2,
                            venda_2024_1
                            ], ignore_index=True) 
    #print(venda.count())

    try:  
        venda.to_excel('dados/view_bi_vendedor_venda.xlsx', index=False)
    except InterruptedError as e:
        print(f'Erro na gravação o arquivo de venda: {e}')



if __name__ == '__main__':
    #concat_devolucao()
    concat_venda()

