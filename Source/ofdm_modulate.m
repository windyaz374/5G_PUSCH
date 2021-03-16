function [waveform info] = ofdm_modulate(grid,mu,NbwpPrb,cptype,NTxant)
%define parameters
info = ofdminfo(NbwpPrb,mu,cptype);
info.NTxant = NTxant;
nSC = info.NSubcarriers;
nFFT = info.Nfft;
cpLengths = info.CyclicPrefixLengths;
symbolsPerSubframe = info.SymbolsPerSubframe;
N = info.Windowing;

% Get dimensional information derived from the resource grid
nSymbols = size(grid,2);
nAnts = size(grid,3);
initialsymbol = 0;
nSubframes = ceil(nSymbols/symbolsPerSubframe);
%pre-calculate windowing`
    % Window size will be nFFT + N + CP length
    window0 = raised_cosine_window(nFFT+cpLengths(1),N);
    window1 = raised_cosine_window(nFFT+cpLengths(2),N);
        
    % Extension periods (prefix, zero suffix) for symbols, accounting 
    % for any required for the windowing
    exLengths = [cpLengths+N; zeros(size(cpLengths))];
    
    % Inter-symbol distances
    % Current stride length is the distance between the current symbol
    % and the start of the next one
    strideLengths = cpLengths + nFFT;
        
    % Amount of overlap between extended symbols
    o = N;
   
    % Initialize starting position of first extended symbol in output waveform
    % With CP-OFDM, the windowing part will warp around into the end of
    % last symbol in the grid block
    pos = -N;
        
    % Midpoints between the extended symbols
    info.Midpoints = cumsum([1+pos+fix(o/2) repmat(strideLengths,[1 nSubframes])]); 
                   
    % Overlap between windowed, extended symbols           
    info.WindowOverlap = N*ones(size(cpLengths));
    
% Index of first subcarrier in IFFT input
    firstSC = (nFFT/2) - (NbwpPrb*6) + 1;
% Create storage for the returned waveform
nsamples = sum(cpLengths(mod(initialsymbol + (0:nSymbols-1),symbolsPerSubframe)+1)) + nFFT*nSymbols;
waveform = zeros(nsamples,nAnts);
includezsc = 1;
for i=1:nSymbols
    currentsymbol = initialsymbol+i-1;
    
	if (size(grid,1)==nFFT)
		ifftin = squeeze(grid(:,i,:));
	else
        ifftin = zeros(nFFT,nAnts);
        ifftin(firstSC+(0:nSC/2-1),:) = grid(1:nSC/2,i,:);
        ifftin(firstSC+nSC/2+(includezsc==0)+(0:nSC/2-1),:) = grid(nSC/2+1:end,i,:);
    end
	%perform ifft
	iffout = ifft(fftshift(ifftin,1));
	 % Add cyclic extension to the symbol 
        exLength = exLengths(:,mod(currentsymbol,length(exLengths))+1);   % Extension lengths (CP/CS) for current symbol
        stride = strideLengths(mod(currentsymbol,length(strideLengths))+1);
        
        % Create extended symbol
        extended = [iffout(end-(exLength(1))+1:end,:); iffout; iffout(1:(exLength(2)),:)];
               
        % Perform windowing, using the appropriate window (first OFDM symbol
        % of half a subframe (0.5ms))
        if (mod(currentsymbol,symbolsPerSubframe/2)==0)
            windowed = extended .* window0;
        else
            windowed = extended .* window1;
        end

        % Perform overlapping and creation of output signal. Note that with
        % windowing the signal "head" gets chopped off the start of the
        % waveform and finally superposed on the end. This means the
        % overall signal can be seamlessly looped when output from an
        % arbitrary waveform generator
        if (i==1)
            % For the first OFDM symbol, chop the windowed "head" (which 
            % will be added to the final waveform end) and then output the
            % rest (rotate around the waveform)
            p = max(-pos,0);
            head = windowed(1:p,:);                 % Part of leading edge of extended symbol which overlaps with previous one (which here will be the last symbol)
            L = size(windowed,1) - size(head,1);    % Length of extended symbol which doesn't overlap with previous symbol
            p = max(pos,0);
            waveform(p+(1:L),:) = windowed(size(head,1)+1:end,:);  % Write non-overlapped (on leading edge) part of waveform to output                      
        else
            % For subsequent OFDM symbols, add the windowed part to the end
            % of the previous OFDM symbol (overlapping them) and then output
            % the rest; 'pos' points to the end of the previous OFDM symbol
            % i.e. the start of the current one, so merge it from N samples
            L = size(windowed,1);
            waveform(pos+(1:L),:) = waveform(pos+(1:L),:) + windowed;            
        end

        % Update 'pos' to point to the start of the next extended OFDM
        % symbol in the output waveform
        pos = pos + stride;         
    end

    % Finally, overlap the "head" with the very end of the signal
    waveform(end-size(head,1)+1:end,:) = waveform(end-size(head,1)+1:end,:) + head;
end

function p = raised_cosine_window(n,w)
    
    p = 0.5*(1-sin(pi*(w+1-2*(1:w).')/(2*w)));
    p = [p; ones(n-w,1); flipud(p)];
    
end