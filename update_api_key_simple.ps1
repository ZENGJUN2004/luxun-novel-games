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
        $content = $content -replace '<br>\s*API KEY:<br>\s*<input type="password" id="api-key" placeholder="输入硅基流动 Key">\s*<br><br>', ''
        
        # 2. 修改callAI函数中的API Key获取方式
        $content = $content -replace 'const key = document\.getElementById\("api-key"\)\.value\.trim\(\);', 'const key = localStorage.getItem("siliconFlowApiKey");'
        
        # 3. 修改callAI函数中的空值检查
        $content = $content -replace 'if\(!key\) return null;', 'if (!key) {\n                alert("请先在目录页输入并保存硅基流动 API Key");\n                window.location.href = "index.html";\n                return null;\n            }'
        
        # 4. 修改startDrama函数中的API Key获取方式
        $content = $content -replace 'const key = document\.getElementById\("api-key"\)\.value\.trim\(\);', 'const key = localStorage.getItem("siliconFlowApiKey");'
        
        # 5. 修改startDrama函数中的空值检查
        $content = $content -replace 'if\(!key\) {\s*alert\("请先输入 API KEY"\);\s*return;\s*}', 'if(!key) {\n                alert("请先在目录页输入并保存硅基流动 API Key");\n                window.location.href = "index.html";\n                return;\n            }'
        
        # 6. 修改toggleDrama函数中的API Key获取方式（如果存在）
        $content = $content -replace 'const key = document\.getElementById\("api-key"\)\.value\.trim\(\);', 'const key = localStorage.getItem("siliconFlowApiKey");'
        
        # 7. 修改toggleDrama函数中的空值检查（如果存在）
        $content = $content -replace 'if\(!key\) return alert\("请输入 API Key"\);', 'if(!key) {\n                alert("请先在目录页输入并保存硅基流动 API Key");\n                window.location.href = "index.html";\n                return;\n            }'
        
        # 8. 添加API调用失败的提示
        $content = $content -replace 'console\.error\("AI调用失败:", e\);\s*return null;', 'console.error("AI调用失败:", e);\n                alert("API 调用失败，请检查 API Key 是否正确");\n                return null;'
        
        # 保存修改后的内容
        Set-Content -Path $filePath -Value $content -Encoding UTF8
        
        Write-Host "文件 $file 处理完成"
    } else {
        Write-Host "文件不存在: $file"
    }
}

Write-Host "所有文件处理完成！"
