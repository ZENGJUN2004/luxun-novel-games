# 批量更新鲁迅小说游戏文件的API Key处理方式
# 将API Key输入功能移到目录页，使用localStorage存储

# 文件列表
$files = @(
    "meijianchi.html",
    "qishi.html",
    "zhujian.html",
    "caiwei.html",
    "butian.html",
    "bengyue.html",
    "gaolaofuzi.html",
    "lihun.html",
    "shansi.html",
    "xingfudejiating.html",
    "mintian.html",
    "yao.html",
    "kongyiji.html",
    "yijianxiaoshi.html",
    "daixu.html"
)

# 遍历每个文件
foreach ($file in $files) {
    $filePath = Join-Path -Path "d:\myapp\skills\鲁迅小说游戏" -ChildPath $file
    
    if (Test-Path $filePath) {
        Write-Host "正在处理文件: $file"
        
        # 读取文件内容
        $content = Get-Content -Path $filePath -Encoding UTF8 -Raw
        
        # 1. 移除API Key输入框
        $content = $content -replace "\s*<br>\s*API KEY:<br>\s*<input type=\"password\" id=\"api-key\" placeholder=\"输入硅基流动 Key\">\s*<br><br>\s*", ""
        
        # 2. 修改callAI函数
        $oldCallAI = @'        async function callAI(system, user) {
            const key = document.getElementById('api-key').value.trim();
            if(!key) return null;
            try {
                const resp = await fetch('https://api.siliconflow.cn/v1/chat/completions', {
                    method: 'POST',
                    headers: { 
                        'Authorization': `Bearer ${key}`, 
                        'Content-Type': 'application/json' 
                    },
                    body: JSON.stringify({
                        model: "deepseek-ai/DeepSeek-V3",
                        messages: [{role:"system", content:system}, {role:"user", content:user}],
                        temperature: 0.85
                    })
                });
                const data = await resp.json();
                return data.choices[0].message.content;
            } catch(e) {
                console.error("AI调用失败:", e);
                return null;
            }
        }'@
        
        $newCallAI = @'        async function callAI(system, user) {
            const key = localStorage.getItem('siliconFlowApiKey');
            if (!key) {
                alert('请先在目录页输入并保存硅基流动 API Key');
                window.location.href = 'index.html';
                return null;
            }
            try {
                const resp = await fetch('https://api.siliconflow.cn/v1/chat/completions', {
                    method: 'POST',
                    headers: { 
                        'Authorization': `Bearer ${key}`, 
                        'Content-Type': 'application/json' 
                    },
                    body: JSON.stringify({
                        model: "deepseek-ai/DeepSeek-V3",
                        messages: [{role:"system", content:system}, {role:"user", content:user}],
                        temperature: 0.85
                    })
                });
                const data = await resp.json();
                return data.choices[0].message.content;
            } catch(e) {
                console.error("AI调用失败:", e);
                alert('API 调用失败，请检查 API Key 是否正确');
                return null;
            }
        }'@
        
        $content = $content -replace [regex]::Escape($oldCallAI), $newCallAI
        
        # 3. 修改startDrama函数
        $oldStartDrama = @'        async function startDrama() {
            const key = document.getElementById('api-key').value.trim();
            if(!key) { 
                alert("请先输入 API KEY"); 
                return; 
            }
            
            isPlaying = true;
            document.getElementById('start-btn').disabled = true;
            document.getElementById('drama-status').style.display = 'block';
            
            startTimer();
            dramaLoop();
        }'@
        
        $newStartDrama = @'        async function startDrama() {
            const key = localStorage.getItem('siliconFlowApiKey');
            if(!key) {
                alert('请先在目录页输入并保存硅基流动 API Key');
                window.location.href = 'index.html';
                return;
            }
            
            isPlaying = true;
            document.getElementById('start-btn').disabled = true;
            document.getElementById('drama-status').style.display = 'block';
            
            startTimer();
            dramaLoop();
        }'@
        
        $content = $content -replace [regex]::Escape($oldStartDrama), $newStartDrama
        
        # 4. 对于使用toggleDrama的文件（如祝福.html），也需要修改
        $oldToggleDrama = @'        async function toggleDrama() {
            const key = document.getElementById('api-key').value.trim();
            if(!key) return alert("请输入 API Key");'@
        
        $newToggleDrama = @'        async function toggleDrama() {
            const key = localStorage.getItem('siliconFlowApiKey');
            if(!key) {
                alert('请先在目录页输入并保存硅基流动 API Key');
                window.location.href = 'index.html';
                return;
            }'@
        
        $content = $content -replace [regex]::Escape($oldToggleDrama), $newToggleDrama
        
        # 保存修改后的内容
        Set-Content -Path $filePath -Value $content -Encoding UTF8
        
        Write-Host "文件 $file 处理完成"
    } else {
        Write-Host "文件不存在: $file"
    }
}

Write-Host "所有文件处理完成！"
