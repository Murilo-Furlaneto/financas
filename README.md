Este aplicativo Flutter permite que os usuários gerenciem suas finanças pessoais de forma eficiente, oferecendo funcionalidades completas para controle de gastos e visualização de dados. O aplicativo utiliza o GetX para gerenciamento de estado, garantindo um desenvolvimento ágil e uma performance otimizada.
Funcionalidades Principais

    Autenticação:

        Login, cadastro e recuperação de senha.

        Armazenamento seguro de usuários e acessos no Firebase.

        Comunicação com um servidor externo para autenticação.

        Identificação e redirecionamento do usuário para as funcionalidades do app.

        Restauração automática do usuário que já fez login anteriormente.

    Gerenciamento de Perfil:

        Upload e restauração de imagem de perfil (câmera ou galeria).

    Contas:

        Cadastro, armazenamento e visualização de contas.

    Tela Inicial (Home Screen):

        Funcionalidade principal para salvar as despesas mensais.

        Layout com gráficos interativos mostrando o pico de movimentação financeira por dia da semana.

    Gerenciamento de Estado:

        Utilização do GetX para todos os módulos, garantindo reatividade e simplicidade no gerenciamento de estados

    Outros:

        Launcher Icons personalizados.

        Suporte a diferentes ambientes (dev, teste, produção) via Flavors.

        Handle de imagens para upload e restauração do Storage.

Arquitetura

O aplicativo foi desenvolvido utilizando a arquitetura MVVM, visando a separação de responsabilidades e a facilidade de manutenção.
Tecnologias Utilizadas

    Flutter

    Dart

    GetX (Gerenciamento de Estado)

    Firebase (Autenticação e Armazenamento)

Como Executar o Projeto

    Clone o repositório.

    Execute flutter pub get para instalar as dependências.

    Execute flutter run para rodar o aplicativo.
