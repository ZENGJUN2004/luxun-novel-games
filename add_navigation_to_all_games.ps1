# 为所有鲁迅小说游戏添加导航功能

$gameDir = "D:\myapp\skills\鲁迅小说游戏"
$htmlFiles = Get-ChildItem -Path $gameDir -Filter "*.html" | Where-Object { $_.Name -ne "index.html" -and $_.Name -ne "test_navigation.html" }

# 游戏数据 - 按照呐喊、彷徨、故事新编的顺序排列
$games = @(
    @{
        id = "luxun-douxu"
        name = "鲁迅小说-代序"
        description = "鲁迅小说《我怎么做起小说来》的交互式游戏"
        path = "daixu.html"
        order = 1
    },
    @{
        id = "luxun-yijianxiaoshi"
        name = "鲁迅小说-一件小事"
        description = "鲁迅小说《一件小事》的交互式游戏"
        path = "yijianxiaoshi.html"
        order = 2
    },
    @{
        id = "luxun-kongyiji"
        name = "鲁迅小说-孔乙己"
        description = "鲁迅小说《孔乙己》的交互式游戏"
        path = "kongyiji.html"
        order = 3
    },
    @{
        id = "luxun-yao"
        name = "鲁迅小说-药"
        description = "鲁迅小说《药》的交互式游戏"
        path = "yao.html"
        order = 4
    },
    @{
        id = "luxun-mintian"
        name = "鲁迅小说-明天"
        description = "鲁迅小说《明天》的交互式游戏"
        path = "mintian.html"
        order = 5
    },
    @{
        id = "luxun-shexi"
        name = "鲁迅小说-社戏"
        description = "鲁迅小说《社戏》的交互式游戏"
        path = "shexi.html"
        order = 6
    },
    @{
        id = "luxun-guxiang"
        name = "鲁迅小说-故乡"
        description = "鲁迅小说《故乡》的交互式游戏"
        path = "guxiang.html"
        order = 7
    },
    @{
        id = "luxun-xingfudejiating"
        name = "鲁迅小说-幸福的家庭"
        description = "鲁迅小说《幸福的家庭》的交互式游戏"
        path = "xingfudejiating.html"
        order = 8
    },
    @{
        id = "luxun-shansi"
        name = "鲁迅小说-伤逝"
        description = "鲁迅小说《伤逝》的交互式游戏"
        path = "shansi.html"
        order = 9
    },
    @{
        id = "luxun-lihun"
        name = "鲁迅小说-离婚"
        description = "鲁迅小说《离婚》的交互式游戏"
        path = "lihun.html"
        order = 10
    },
    @{
        id = "luxun-gaolaofuzi"
        name = "鲁迅小说-高老夫子"
        description = "鲁迅小说《高老夫子》的交互式游戏"
        path = "gaolaofuzi.html"
        order = 11
    },
    @{
        id = "luxun-bengyue"
        name = "鲁迅小说-奔月"
        description = "鲁迅小说《奔月》的交互式游戏"
        path = "bengyue.html"
        order = 12
    },
    @{
        id = "luxun-butian"
        name = "鲁迅小说-补天"
        description = "鲁迅小说《补天》的交互式游戏"
        path = "butian.html"
        order = 13
    },
    @{
        id = "luxun-caiwei"
        name = "鲁迅小说-采薇"
        description = "鲁迅小说《采薇》的交互式游戏"
        path = "caiwei.html"
        order = 14
    },
    @{
        id = "luxun-zhujian"
        name = "鲁迅小说-铸剑"
        description = "鲁迅小说《铸剑》的交互式游戏"
        path = "zhujian.html"
        order = 15
    },
    @{
        id = "luxun-qishi"
        name = "鲁迅小说-起死"
        description = "鲁迅小说《起死》的交互式游戏"
        path = "qishi.html"
        order = 16
    },
    @{
        id = "luxun-huaijiu"
        name = "鲁迅小说-怀旧"
        description = "鲁迅小说《怀旧》的交互式游戏"
        path = "huaijiu.html"
        order = 17
    }
)

# 生成游戏数据JavaScript代码
$gamesJs = "const games = [" + "`n"
foreach ($game in $games) {
    $gamesJs += "    {" + "`n"
    $gamesJs += "        id: \"$($game.id)\"," + "`n"
    $gamesJs += "        name: \"$($game.name)\"," + "`n"
    $gamesJs += "        description: \"$($game.description)\"," + "`n"
    $gamesJs += "        path: \"$($game.path)\"," + "`n"
    $gamesJs += "        order: $($game.order)" + "`n"
    $gamesJs += "    }," + "`n"
}
$gamesJs = $gamesJs.Substring(0, $gamesJs.Length - 2) + "`n];"

# 导航功能脚本
$navScript = @"

    <!-- 导航功能脚本 -->
    <script>
        $gamesJs

        // 获取游戏按顺序
        function getGameByOrder(order) {
            return games.find(game => game.order === order);
        }

        // 获取上一篇游戏
        function getPreviousGame(currentOrder) {
            if (currentOrder <= 1) return null;
            return getGameByOrder(currentOrder - 1);
        }

        // 获取下一篇游戏
        function getNextGame(currentOrder) {
            const maxOrder = Math.max(...games.map(game => game.order));
            if (currentOrder >= maxOrder) return null;
            return getGameByOrder(currentOrder + 1);
        }

        // 导航功能
        function navigateToPrevious() {
            console.log('点击了上一篇按钮');
            console.log('游戏数量:', games.length);
            
            // 获取当前文件名
            const currentUrl = window.location.href;
            const currentFileName = currentUrl.split('/').pop();
            console.log('当前文件名:', currentFileName);
            
            // 查找当前游戏
            let currentGame = null;
            if (currentFileName) {
                currentGame = games.find(game => {
                    console.log('检查游戏:', game.name, '路径:', game.path);
                    return game.path === currentFileName;
                });
            }

            console.log('当前游戏:', currentGame);
            
            if (currentGame) {
                const previousGame = getPreviousGame(currentGame.order);
                console.log('上一篇游戏:', previousGame);
                if (previousGame) {
                    console.log('导航到:', previousGame.path);
                    window.location.href = previousGame.path;
                } else {
                    console.log('已经是第一篇，导航回index.html');
                    window.location.href = 'index.html';
                }
            } else {
                console.log('未找到当前游戏，导航回index.html');
                window.location.href = 'index.html';
            }
        }

        function navigateToNext() {
            console.log('点击了下一篇按钮');
            console.log('游戏数量:', games.length);
            
            // 获取当前文件名
            const currentUrl = window.location.href;
            const currentFileName = currentUrl.split('/').pop();
            console.log('当前文件名:', currentFileName);
            
            // 查找当前游戏
            let currentGame = null;
            if (currentFileName) {
                currentGame = games.find(game => {
                    console.log('检查游戏:', game.name, '路径:', game.path);
                    return game.path === currentFileName;
                });
            }

            console.log('当前游戏:', currentGame);
            
            if (currentGame) {
                const nextGame = getNextGame(currentGame.order);
                console.log('下一篇游戏:', nextGame);
                if (nextGame) {
                    console.log('导航到:', nextGame.path);
                    window.location.href = nextGame.path;
                }
            } else {
                console.log('未找到当前游戏，导航到第一篇游戏');
                const firstGame = getGameByOrder(1);
                if (firstGame) {
                    window.location.href = firstGame.path;
                }
            }
        }
    </script>
"@

# 导航栏CSS样式
$navCss = @"

        /* 导航栏 */
        .navigation {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 20px 0;
            padding: 15px;
            background: rgba(139, 69, 19, 0.2);
            border-radius: 8px;
            border: 1px solid var(--book-brown);
        }

        .nav-button {
            background: linear-gradient(145deg, var(--gold), #b8860b);
            color: white;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border: none;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
        }

        .nav-button:hover {
            background: linear-gradient(145deg, #b8860b, var(--gold));
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(212, 175, 55, 0.4);
        }

        .nav-button:disabled {
            background: #555;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
"@

# 导航按钮HTML
$navHtml = @"
    <!-- 导航栏 -->
    <div class="navigation">
        <button class="nav-button" onclick="navigateToPrevious()">上一篇</button>
        <a href="index.html" class="nav-button">目录</a>
        <button class="nav-button" onclick="navigateToNext()">下一篇</button>
    </div>

"@

foreach ($file in $htmlFiles) {
    Write-Host "正在处理文件: $($file.Name)"
    
    try {
        $content = Get-Content -Path $file.FullName -Encoding UTF8 -Raw
        
        # 检查是否已经添加了导航功能
        if ($content -notmatch "navigation") {
            # 添加CSS样式
            $content = $content -replace '(#theater-view \{[^}]+\})', "`$1$navCss"
            
            # 更新theater-view高度
            $content = $content -replace 'height: calc\(100vh - 40px\);', 'height: calc(100vh - 120px);'
            
            # 添加导航按钮HTML
            $content = $content -replace '<div id="main-stage">', "$navHtml    <div id="main-stage">"
            
            # 添加导航功能脚本
            $content = $content -replace '</body>', "$navScript</body>"
            
            # 保存修改后的文件
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8
            Write-Host "已成功添加导航功能: $($file.Name)"
        } else {
            Write-Host "文件已经包含导航功能: $($file.Name)"
        }
    } catch {
        Write-Host "处理文件时出错: $($file.Name)"
        Write-Host "错误信息: $($_.Exception.Message)"
    }
}

# 更新index.html文件中的游戏顺序
Write-Host "正在更新index.html文件中的游戏顺序..."
try {
    $indexFile = Join-Path -Path $gameDir -ChildPath "index.html"
    $indexContent = Get-Content -Path $indexFile -Encoding UTF8 -Raw
    
    # 生成游戏数据JavaScript代码
    $indexGamesJs = "const games = [" + "`n"
    foreach ($game in $games) {
        $indexGamesJs += "    {" + "`n"
        $indexGamesJs += "        id: \"$($game.id)\"," + "`n"
        $indexGamesJs += "        name: \"$($game.name)\"," + "`n"
        $indexGamesJs += "        description: \"$($game.description)\"," + "`n"
        $indexGamesJs += "        path: \"$($game.path)\"," + "`n"
        $indexGamesJs += "        order: $($game.order)" + "`n"
        $indexGamesJs += "    }," + "`n"
    }
    $indexGamesJs = $indexGamesJs.Substring(0, $indexGamesJs.Length - 2) + "`n];"
    
    # 替换index.html中的游戏数据
    $indexContent = $indexContent -replace 'const games = \[.*?\];', $indexGamesJs
    
    # 保存修改后的文件
    Set-Content -Path $indexFile -Value $indexContent -Encoding UTF8
    Write-Host "已成功更新index.html文件中的游戏顺序"
} catch {
    Write-Host "更新index.html文件时出错"
    Write-Host "错误信息: $($_.Exception.Message)"
}

Write-Host "所有文件处理完成!"
