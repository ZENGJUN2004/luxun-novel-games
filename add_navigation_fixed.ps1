# 为所有鲁迅小说游戏页面添加导航功能

$gameDir = "D:\myapp\skills\鲁迅小说游戏"
$htmlFiles = Get-ChildItem -Path $gameDir -Filter "*.html" | Where-Object { $_.Name -ne "index.html" }

foreach ($file in $htmlFiles) {
    Write-Host "正在处理文件: $($file.Name)"
    
    try {
        $content = Get-Content -Path $file.FullName -Encoding UTF8 -Raw
        
        # 检查是否已经添加了导航功能
        if ($content -notmatch "navigation") {
            # 添加CSS样式
            $cssToAdd = @"

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
            
            # 在theater-view样式后添加导航栏样式
            $content = $content -replace '(#theater-view \{[^}]+\})', "`$1$cssToAdd"
            
            # 更新theater-view高度
            $content = $content -replace 'height: calc\(100vh - 40px\);', 'height: calc(100vh - 120px);'
            
            # 添加导航按钮HTML
            $navHtml = @"
    <!-- 导航栏 -->
    <div class="navigation">
        <button class="nav-button" onclick="navigateToPrevious()">上一篇</button>
        <a href="index.html" class="nav-button">目录</a>
        <button class="nav-button" onclick="navigateToNext()">下一篇</button>
    </div>

"@
            
            $content = $content -replace '<div id="main-stage">', "$navHtml    <div id="main-stage">"
            
            # 添加导航功能脚本
            $navScript = @"

    <!-- 导航功能脚本 -->
    <script>
        // 技能管理系统
        class SkillManagementSystem {
            constructor() {
                this.config = null;
                this.skills = [];
                this.currentSkill = null;
                this.init();
            }

            async init() {
                try {
                    // 加载配置文件
                    const response = await fetch('../skill-management-system/config.json');
                    this.config = await response.json();
                    this.skills = this.config.skills;
                    console.log('技能管理系统初始化成功');
                    console.log(`加载了 ${this.skills.length} 个技能`);
                } catch (error) {
                    console.error('技能管理系统初始化失败:', error);
                }
            }

            getSkillByOrder(order) {
                return this.skills.find(skill => skill.order === order);
            }

            getPreviousSkill(currentOrder) {
                if (currentOrder <= 1) return null;
                return this.getSkillByOrder(currentOrder - 1);
            }

            getNextSkill(currentOrder) {
                const maxOrder = Math.max(...this.skills.map(skill => skill.order));
                if (currentOrder >= maxOrder) return null;
                return this.getSkillByOrder(currentOrder + 1);
            }
        }

        // 初始化技能管理系统
        const skillSystem = new SkillManagementSystem();

        // 导航功能
        function navigateToPrevious() {
            // 获取当前技能顺序
            const currentUrl = window.location.href;
            const currentFileName = currentUrl.split('/').pop();
            
            // 查找当前技能
            let currentSkill = null;
            if (currentFileName) {
                currentSkill = skillSystem.skills.find(skill => {
                    const skillFileName = skill.path.split('/').pop();
                    return skillFileName === currentFileName;
                });
            }

            if (currentSkill) {
                const previousSkill = skillSystem.getPreviousSkill(currentSkill.order);
                if (previousSkill) {
                    window.location.href = previousSkill.path;
                } else {
                    // 已经是第一篇，导航回index.html
                    window.location.href = 'index.html';
                }
            }
        }

        function navigateToNext() {
            // 获取当前技能顺序
            const currentUrl = window.location.href;
            const currentFileName = currentUrl.split('/').pop();
            
            // 查找当前技能
            let currentSkill = null;
            if (currentFileName) {
                currentSkill = skillSystem.skills.find(skill => {
                    const skillFileName = skill.path.split('/').pop();
                    return skillFileName === currentFileName;
                });
            }

            if (currentSkill) {
                const nextSkill = skillSystem.getNextSkill(currentSkill.order);
                if (nextSkill) {
                    window.location.href = nextSkill.path;
                }
            }
        }
    </script>
"@
            
            # 在</body>前添加导航脚本
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

Write-Host "所有文件处理完成!"